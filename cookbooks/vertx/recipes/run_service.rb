
node[:vertx][:mods].each do |mod|

mod_conf = data_bag_item(:vertx, mod)[ node.chef_environment ]
mod_name = mod_conf['mod']

template node[:vertx][:mods_dir] + "/" + mod_name + ".run" do
  source        "supervisor-vertx-run.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0750"
  variables     :vertx => node[:vertx], :mod_conf => mod_conf
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

template node[:vertx][:supervisor_conf_dir] + "/" + mod_name + ".conf" do
  source        "supervisor-service.conf.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx], :mod_conf => mod_conf
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

template node[:vertx][:mods_dir] + "/" + mod_name + "-logging.properties" do
  source        "logging.properties.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx], :mod_conf => mod_conf
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

end

