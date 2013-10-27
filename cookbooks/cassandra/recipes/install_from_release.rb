#
# Cookbook Name::       cassandra
# Description::         Install From Release
# Recipe::              install_from_release
# Author::              Benjamin Black
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

# == Users

daemon_user(:cassandra) do
  create_group  true
end

include_recipe 'install_from'

install_from_release(:cassandra) do
  release_url   node[:cassandra][:release_url]
  home_dir      node[:cassandra][:home_dir]
  version       node[:cassandra][:version]
  action        [:install]
  has_binaries  [ 'bin/cassandra' ]
  not_if{ ::File.exists?("#{node[:cassandra][:install_dir]}/bin/cassandra") }
end

#link "#{node[:cassandra][:home_dir]}/cassandra.in.sh" do
#  to "#{node[:cassandra][:home_dir]}/bin/cassandra.in.sh"
#  action        :create
#end

include_recipe "cassandra::bintools"


