#
# Cookbook Name:: vertx
# Recipe:: default
#
# Copyright 2013, citizenme
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

daemon_user(:vertx) do
  action        :create
  create_group  true
end

include_recipe 'install_from'

install_from_release(:vertx) do
  release_url   node[:vertx][:release_url]
  home_dir      node[:vertx][:home_dir]
  version       node[:vertx][:version]
  action        [:install]
  has_binaries  [ 'bin/vertx' ]
  not_if{ ::File.exists?("#{node[:vertx][:install_dir]}/bin/vertx") }
end

directory node[:vertx][:pid_dir] do
  owner node[:vertx][:user]
  group node[:vertx][:group]
  recursive true
  action :create
end

directory node[:vertx][:log_dir] do
  owner node[:vertx][:user]
  group node[:vertx][:group]
  action :create
end

directory node[:vertx][:mods_dir] do
  owner node[:vertx][:user]
  group node[:vertx][:group]
  action :create
end

directory node[:vertx][:sys_mods_dir] do
  owner node[:vertx][:user]
  group node[:vertx][:group]
  action :create
end

template "#{node[:vertx][:conf_dir]}/repos.txt" do
  source        "repos.txt.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

template "#{node[:vertx][:conf_dir]}/cluster.xml" do
  source        "cluster.xml.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

remote_file "#{node[:vertx][:lib_dir]}/hazelcast-cloud-#{node[:vertx][:hazelcast][:version]}.jar" do
  source "#{node[:vertx][:hazelcast][:cloud_url]}"
end

# This is a fix for hazelcast bug https://github.com/hazelcast/hazelcast/issues/5653
if node[:vertx][:version] == '2.1.6'
  remote_file "#{node[:vertx][:lib_dir]}/hazelcast-#{node[:vertx][:hazelcast][:version]}.jar" do
    source "#{node[:vertx][:hazelcast][:url]}"
  end

  file "#{node[:vertx][:lib_dir]}/hazelcast-3.5.jar" do
    action	:delete
  end
end
