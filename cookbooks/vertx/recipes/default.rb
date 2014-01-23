#
# Cookbook Name:: vertx
# Recipe:: default
#
# Copyright 2013, citizenme
#
# All rights reserved - Do Not Redistribute
#

daemon_user(:vertx) do
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

template "#{node[:vertx][:conf_dir]}/logging.properties" do
  source        "logging.properties.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end


template "#{node[:vertx][:conf_dir]}/repos.txt" do
  source        "repos.txt.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

