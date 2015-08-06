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
# Various tried-and-failed stuff to play with
#include Opscode::Aws::Ec2
#::Chef::Recipe.send(:include, Opscode::Aws::Ec2)
#chef_gem 'aws-sdk'

include_recipe 'supervisor'
begin
end

include_recipe 'vertx'
begin
end

if node[:pdx][:cluster_type] == "AWS"

  include_recipe 'aws'
  begin
  end

  # We require after ensuring that the aws-sdk gem is installed with aws recipe above
  require 'aws-sdk'

  ec2 = Aws::EC2::Client.new(region: node[:pdx][:aws_region] )

  instance_ids = Array.new

  # Find all registered cluster nodes
  ec2.describe_tags( filters: [ { name: 'resource-type', values: [ "instance" ] }, { name: 'key', values: [ node[:pdx][:aws_cluster_tag_name] ] }, { name: 'value', values: [ node[:pdx][:aws_cluster_tag_value] ] } ] )[:tags].map do |tag|
    instance_ids << tag[:resource_id]
  end

  Chef::Log.warn("instance_ids: " + instance_ids.to_s )

  # Get private IP addresses for registered cluster nodes
  ha_initial_hosts = Array.new
  ec2.describe_instances( instance_ids: instance_ids )[:reservations].map do |reservation|
    reservation[:instances].map do |instance|
      ha_initial_hosts << instance.private_ip_address + ":" + node[:pdx][:neo4j_cluster_port]
    end
  end

  if node[:pdx][:neo4j_ha_initial_hosts].nil?
    node.default[:pdx][:neo4j_ha_initial_hosts] = ha_initial_hosts * ","
  end

  Chef::Log.warn("node[:pdx][:neo4j_ha_initial_hosts] : " + node[:pdx][:neo4j_ha_initial_hosts] )
end

# Create directory for database - owned by vertx user running database and service
directory node[:pdx][:neo4j_db_dir] do
  owner node[:vertx][:user]
  group node[:vertx][:group]
  recursive true
  action :create
end

include_recipe 'vertx::deploy_module'
begin
end

template node[:pdx][:neo4j_properties] do
  source        "neo4j.properties.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :pdx => node[:pdx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

template node[:pdx][:neo4j_server_properties] do
  source        "neo4j-server.properties.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :pdx => node[:pdx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

template node[:pdx][:neo4j_http_log_config] do
  source        "neo4j-http-logging.xml.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :pdx => node[:pdx]
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

# The Neo4j guys are really driving me nuts with their almost "daily" distribution server changes!!!
# Some of them not working with either install_from or ark - sigh...
# ----------------
# Install neo4j distribution for neo4j shell
#include_recipe 'install_from'
#install_from_release(:neo4j) do
#  release_url   node[:pdx][:neo4j_release_url]
#  home_dir      node[:pdx][:neo4j_home_dir]
#  version       node[:pdx][:neo4j_version]
#  action        [:install]
#  has_binaries  [ 'bin/neo4j-shell' ]
#  not_if{ ::File.exists?("#{node[:pdx][:install_dir]}/bin/neo4j-shell") }
#end

script "install_neo4j" do
  interpreter "bash"
  user "root"
  cwd "/usr/local/share"
  environment("URL" => node[:pdx][:neo4_release_url], "EDITION" => node[:pdx][:neo4j_edition], "VERSION" => node[:pdx][:neo4j_version], "USER" => node[:vertx][:user], "GROUP" => node[:vertx][:group] )
  code <<-EOH
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    NEO4J_PACKAGE=neo4j-${EDITION}-${VERSION}
    TMP_DIST=/tmp/${NEO4J_PACKAGE}.tar.gz
    URL="http://neo4j.com/artifact.php?name=neo4j-${EDITION}-${VERSION}-unix.tar.gz"
    echo "URL: $URL - NEO4J_PACKAGE: $NEO4J_PACKAGE - TMP_DIST: $TMP_DIST" >/tmp/log.txt
    [[ ! -f "$TMP_DIST" ]] && curl "$URL" -o $TMP_DIST 2>>/tmp/log.txt
    [[ ! -d "/usr/local/share/$NEO4J_PACKAGE" ]] && tar xvfz $TMP_DIST 2>&1 >>/tmp/log.txt
    chown -R $USER:$GROUP /usr/local/share/$NEO4J_PACKAGE
    [[ -h /usr/share/neo4j ]] && rm -f /usr/share/neo4j
    ln -fs /usr/local/share/$NEO4J_PACKAGE /usr/share/neo4j
  EOH
end

template "/usr/share/neo4j/conf/neo4j.properties" do
  source        "neo4j.properties.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :pdx => node[:pdx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

template "/usr/share/neo4j/conf/neo4j-server.properties" do
  source        "neo4j-server.properties.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :pdx => node[:pdx]
  notifies      :restart, "service[vertx]", :delayed if startable?(node[:vertx])
end

