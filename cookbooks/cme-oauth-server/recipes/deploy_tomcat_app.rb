
# This is a hack from: http://stackoverflow.com/questions/27934224/how-to-restart-tomcat-after-deploying-war-file-with-chef
# because a service[tomcat] restart notification no longer is possible (see later in this file)
ruby_block 'restart_tomcat7' do
  action :nothing
  block do
    resources('service[tomcat7]').run_action(:restart)
  end
end

# Where to dump the <app>.properties file
directory node[:tomcat][:app_conf_dir] do
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
  recursive true
  action :create
end


node[:tomcat][:mods].each do |mod_bag|

mod_conf = data_bag_item("tomcat", mod_bag)[ node.chef_environment ]

mod_name = mod_conf["context_name"]

prop_file_name = node[:tomcat][:app_conf_dir] + "/" + mod_name + ".properties"
context_file_name = node[:tomcat][:context_dir] + "/" + mod_name + ".xml"

# The <app>.properties files
template prop_file_name do
  source        "app.properties.erb"
  owner         node[:tomcat][:user]
  group         node[:tomcat][:group]
  mode          "0644"
  variables     :tomcat => node[:tomcat], :mod_conf => mod_conf
  notifies      :restart, "ruby_block[restart_tomcat7]"
#  notifies      :restart, "service[tomcat7]"
#  notifies      :restart, "service[tomcat#{node['tomcat']['base_version']}]"
end

# The <app>.xml file providing the context of app and therefore location of <app>.properties file
template context_file_name do
  source        "context.xml.erb"
  owner         node[:tomcat][:user]
  group         node[:tomcat][:group]
  mode          "0644"
  variables     :tomcat => node[:tomcat], :prop_file_name => prop_file_name
  notifies      :restart, "ruby_block[restart_tomcat7]"
#  notifies      :restart, "service[tomcat7]"
#  notifies      :restart, "service[tomcat#{node['tomcat']['base_version']}]"
end

bash "deploy_war" do
  interpreter "bash"
  user node[:tomcat][:user]
  group node[:tomcat][:group]
  cwd node[:tomcat][:home_dir]
  environment("GROUP_ID" => mod_conf["group_id"],
              "ARTIFACT_ID" => mod_conf["artifact_id"],
              "VERSION" => mod_conf["version"],
              "PACKAGING" => mod_conf["packaging"],
              "DEST_FILE" => node[:tomcat][:webapp_dir] + "/" + mod_name + "." + mod_conf["packaging"]
  )
  code <<-EOH
    NEXUS_BASE=http://build.cloud.citizenme.com/nexus
    REST_PATH=/service/local
    ART_REDIR=/artifact/maven/redirect
    
    CLASSIFIER=\"\"
    REPO=
    
    if [[ -z $GROUP_ID ]] || [[ -z $ARTIFACT_ID ]] || [[ -z $VERSION ]]
    then
         echo \"BAD ARGUMENTS: Either groupId, artifactId, or version was not supplied\" >&2
         usage
         exit 1
    fi
    
    # If the version requested is a SNAPSHOT use snapshots, otherwise use releases
    if [[ \"$VERSION\" =~ \"SNAPSHOT\" ]]
    then
        : ${REPO:=\"snapshots\"}
    else
        : ${REPO:=\"releases\"}
    fi
    
    # Construct the base URL
    REDIRECT_URL=${NEXUS_BASE}${REST_PATH}${ART_REDIR}
     
    # Generate the list of parameters
    PARAM_KEYS=( g a v r p c )
    PARAM_VALUES=( $GROUP_ID $ARTIFACT_ID $VERSION $REPO $PACKAGING $CLASSIFIER )
    PARAMS=\"\"
    for index in ${!PARAM_KEYS[*]} 
    do
      if [[ ${PARAM_VALUES[$index]} != \"\" ]]
      then
        PARAMS=\"${PARAMS}${PARAM_KEYS[$index]}=${PARAM_VALUES[$index]}&\"
      fi
    done
     
    REDIRECT_URL=\"${REDIRECT_URL}?${PARAMS}\"
     
    echo \"Fetching Artifact from $REDIRECT_URL...\" >&2
    
    curl -k -sS -L ${REDIRECT_URL} >$DEST_FILE
    
    EOH
    
  end
end
