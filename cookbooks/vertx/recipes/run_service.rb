
template "#{node[:vertx][:conf_dir]}/#{node[:vertx][:mod]}.run" do
  source        "supervisor-vertx-run.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0750"
  variables     :vertx => node[:vertx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

template "#{node[:vertx][:supervisor_conf_dir]}/#{node[:vertx][:mod]}.conf" do
  source        "supervisor-service.conf.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

