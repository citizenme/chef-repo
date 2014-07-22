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

include_recipe 'vertx::deploy_module'
begin
end

mod_bag = ''
node[:vertx][:mods].each do |m|
  if m.start_with?('citizenme_pdxuser')
    mod_bag = m
end

if ! mod_bag.empty?

  mod_conf = data_bag_item("vertx", mod_bag)[ node.chef_environment ]
  mod_name = mod_conf["mod"]

  template "#{node[:vertx][:mods_dir]}/" + mod_name + "/" + neo4j.properties do
    source        "neo4j.properties.erb"
    owner         node[:vertx][:user]
    group         node[:vertx][:group]
    mode          "0644"
    variables     :vertx => node[:vertx]
    notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
  end
end

include_recipe 'vertx::run_service'
begin
end

