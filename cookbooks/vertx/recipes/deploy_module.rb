
script "deploy_module" do
  interpreter "bash"
  user node[:vertx][:user]
  group node[:vertx][:group]
  cwd node[:vertx][:home_dir]
  environment("VERTX_MODS" => node[:vertx][:mods_dir], "VERTX_HOME" => node[:vertx][:home_dir], "MOD" => node[:vertx][:mod])
  code <<-EOH
    $VERTX_HOME/bin/vertx install "$MOD"
  EOH
end

conf = data_bag_item('vertx', node[:vertx][:mod_conf_name] )[ node.chef_environment ]

open(File.join(node[:vertx][:mods_dir], node[:vertx][:mod] + ".conf"),"w") do |f|
  f.write(conf.to_json)
end

