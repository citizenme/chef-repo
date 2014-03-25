#
# Cookbook Name:: vertx-nginx
# Recipe:: default
#
# Copyright 2014, citizenme
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'nginx'
begin
  r = resources(:template => "#{node['nginx']['dir']}/sites-available/default")
  r.cookbook "vertx-nginx"
rescue Chef::Exceptions::ResourceNotFound
  Chef::Log.warn "could not find template to override!"
end


cert_conf = data_bag_item("vertx-nginx", node['nginx']['server_name'].gsub(".", "_") )

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

