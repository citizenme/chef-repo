#
# Cookbook Name:: tos_sources
# Recipe:: default
#
# Copyright 2014, citizenme
#
# All rights reserved _ Do Not Redistribute
#

include_recipe 'git'

# We need ssh key in here
directory "#{node[:tos_sources][:pid_dir]}/.ssh" do
  owner node[:tos_sources][:user]
  group node[:tos_sources][:group]
  mode 00700
  action :create
end

# We need to refactor all this to use a box standard cookbook to create user and populate key pair
# This is a quick fix due to dependencies down stream in e.g. vertx cookbook
ssh_conf = data_bag_item("tos_sources", "vertx")[ node.chef_environment ]

template node[:tos_sources][:pid_dir] + "/.ssh/id_rsa" do
  source        "id_rsa.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0600"
  variables     :ssh_private_key => ssh_conf["ssh_private_key"]
end

template node[:tos_sources][:pid_dir] + "/.ssh/id_rsa.pub" do
  source        "id_rsa.pub.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0600"
  variables     :ssh_public_key => ssh_conf["ssh_public_key"]
end

template node[:tos_sources][:pid_dir] + "/.ssh/known_hosts" do
  source        "known_hosts.erb"
  owner         node[:vertx][:user]
  group         node[:vertx][:group]
  mode          "0644"
  variables     :known_hosts => ssh_conf["known_hosts"]
end

directory node[:tos_sources][:git_dir] do
  owner node[:tos_sources][:user]
  group node[:tos_sources][:group]
  recursive true
  action :create
end

# citizenme ToS content
git node[:tos_sources][:git_dir] + "/Content" do
  repository node[:tos_sources][:citizenme_tos_url]
  reference node[:tos_sources][:citizenme_tos_branch]
  user  node[:tos_sources][:user]
  group node[:tos_sources][:group]
  action :checkout
end

