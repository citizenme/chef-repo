#
# Cookbook Name::       cassandra
# Description::         Base configuration for cassandra
# Recipe::              default
# Author::              Benjamin Black (<b@b3k.us>)
#
# Copyright 2010, Benjamin Black
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

# == Recipes

include_recipe "silverware"
include_recipe "java" ; complain_if_not_sun_java(:cassandra)


# == Volumes

#include_recipe "volumes"

#standard_dirs('cassandra') do
#  directories   [:conf_dir, :log_dir, :lib_dir, :pid_dir, :data_dirs, :commitlog_dir, :saved_caches_dir]
#  user          node[:cassandra][:user]
#  group         node[:cassandra][:group]
#end

directory node[:cassandra][:conf_dir] do
  owner node[:cassandra][:user]
  group node[:cassandra][:group]
  action :create
end

directory node[:cassandra][:log_dir] do
  owner node[:cassandra][:user]
  group node[:cassandra][:group]
  action :create
end

directory node[:cassandra][:lib_dir] do
  owner node[:cassandra][:user]
  group node[:cassandra][:group]
  action :create
end


directory node[:cassandra][:pid_dir] do
  owner node[:cassandra][:user]
  group node[:cassandra][:group]
  action :create
end

#@node[:cassandra][:data_dirs].each do |data_dir|
node[:cassandra][:data_dirs].each do |data_dir|
  directory data_dir do
    owner node[:cassandra][:user]
    group node[:cassandra][:group]
    action :create
  end
end

directory node[:cassandra][:commitlog_dir] do
  owner node[:cassandra][:user]
  group node[:cassandra][:group]
  action :create
end

directory node[:cassandra][:saved_caches_dir] do
  owner node[:cassandra][:user]
  group node[:cassandra][:group]
  action :create
end

