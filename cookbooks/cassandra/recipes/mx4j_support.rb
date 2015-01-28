#
# Cookbook Name::       cassandra
# Description::         Mx4j
# Recipe::              mx4j
# Author::              Mike Heffner (<mike@librato.com>)
#
# Copyright 2011, Benjamin Black
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

#
# Installs the MX4J jarfile for monitoring
#
# See:
# http://wiki.apache.org/cassandra/Operations#Monitoring_with_MX4J
#
#

include_recipe 'install_from'

# XXX: Only supports Ubuntu x86_64
if node[:platform].downcase == "ubuntu" && node[:kernel][:machine] == "x86_64"

  package "libmx4j-java" do
    action :install
  end

  # Link into our cassandra directory
  link "#{node[:cassandra][:home_dir]}/lib/mx4j-tools.jar" do
    to          "/usr/share/java/mx4j-tools.jar"
    notifies    :restart, "service[cassandra]", :delayed if startable?(node[:cassandra])
  end
else
  Chef::Log.warn("MX4J cookbook not supported on this platform")
end

# FIXME: How to conditionally set this after the jarfile link has been  put in place?
node.default[:cassandra][:enable_mx4j] = true

