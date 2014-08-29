#
# Cookbook Name:: pdx-server
# Recipe:: default
#
# Copyright (C) 2014 citizenme
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'supervisor'
begin
end

include_recipe 'vertx'
begin
#  r = resources(:template => "#{node['nginx']['dir']}/sites-available/default")
#  r.cookbook "vertx-nginx"
#rescue Chef::Exceptions::ResourceNotFound
#  Chef::Log.warn "could not find template to override!"
end

# Create directory for database - owned by vertx user running database and service
directory node[:pdx][:db_dir] do
  owner node[:vertx][:user]
  group node[:vertx][:group]
  recursive true
  action :create
end

include_recipe 'vertx::deploy_module'
begin
end

template "#{node[:pdx][:db_dir]}/neo4j.properties" do
  source        "neo4j.properties.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :vertx => node[:vertx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

include_recipe 'vertx::run_service'
begin
end

include_recipe 'nginx'
begin
  r = resources(:template => "#{node['nginx']['dir']}/sites-available/default")
  r.cookbook "pdx-server"
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn "could not find template to override!"
end

cert_conf = data_bag_item("pdx-server", node['nginx']['server_name'].gsub(".", "_") )

template "/etc/ssl/certs/" + node['nginx']['server_name'] + ".pem" do
  source        "certificate.erb"
  owner         node['nginx']['user']
  group         node['nginx']['group']
  mode          "0600"
  variables     :nginx => node[:nginx], :certificate => cert_conf["certificate"]
  notifies      :restart, "service[nginx]"
end

template "/etc/ssl/private/" + node['nginx']['server_name'] + ".key" do
  source        "key.erb"
  owner         node['nginx']['user']
  group         node['nginx']['group']
  mode          "0600"
  variables     :nginx => node[:nginx], :key => cert_conf["key"]
  notifies      :restart, "service[nginx]"
end

