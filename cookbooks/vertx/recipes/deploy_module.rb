
require 'json'

node[:vertx][:mods].each do |mod_bag|

mod_conf = data_bag_item("vertx", mod_bag)[ node.chef_environment ]
mod_name = mod_conf["mod"]

script "undeploy_module" do
  interpreter "bash"
  user node[:vertx][:user]
  group node[:vertx][:group]
  cwd node[:vertx][:home_dir]
  environment("VERTX_MODS" => node[:vertx][:mods_dir], "VERTX_HOME" => node[:vertx][:home_dir], "MOD" => mod_name )
  code <<-EOH
    if [ -d "$VERTX_MODS/$MOD" ] ; then
      $VERTX_HOME/bin/vertx uninstall "$MOD"
    fi
  EOH
end

script "deploy_module" do
  interpreter "bash"
  user node[:vertx][:user]
  group node[:vertx][:group]
  cwd node[:vertx][:home_dir]
  environment("VERTX_MODS" => node[:vertx][:mods_dir], "VERTX_HOME" => node[:vertx][:home_dir], "MOD" => mod_name )
  code <<-EOH
    $VERTX_HOME/bin/vertx install "$MOD"
  EOH
end

script "pulldeps_module" do
  interpreter "bash"
  user node[:vertx][:user]
  group node[:vertx][:group]
  cwd node[:vertx][:home_dir]
  environment("VERTX_MODS" => node[:vertx][:mods_dir], "VERTX_HOME" => node[:vertx][:home_dir], "MOD" => mod_name )
  code <<-EOH
    $VERTX_HOME/bin/vertx pulldeps "$MOD"
  EOH
end

#open(File.join(node[:vertx][:mods_dir], mod_name + ".conf"),"w") do |f|
#  f.write(mod_conf['config'].to_json)
#end

template node[:vertx][:mods_dir] + "/" + mod_name + ".conf" do
  source        "module-config.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx], :mod_conf => mod_conf
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end


#file File.join(node[:vertx][:mods_dir], mod_conf["mod"] + ".conf") do
#  owner "vertx"
#  group "vertx"
#  mode "0640"
#  action :touch
#end

end
