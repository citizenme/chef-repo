#
# Cookbook Name:: tos_sources
# Recipe:: default
#
# Copyright 2014, citizenme
#
# All rights reserved _ Do Not Redistribute
#

include_recipe 'git'

daemon_user(:tos_sources) do
  create_group  true
end

directory node[:tos_sources][:git_dir] do
  owner node[:tos_sources][:user]
  group node[:tos_sources][:group]
  recursive true
  action :create
end

# ToS;DR
git node[:tos_sources][:git_dir] + "/tosdr.org" do
  repository node[:tos_sources][:tosdr_repo_url]
  reference "master"
  user  node[:tos_sources][:user]
  group node[:tos_sources][:group]
  action :checkout
end

cron "tosdr" do
  action :create
  minute "*/5"
  user node[:tos_sources][:user]
  mailto "morten@citizenme.com"
  home node[:tos_sources][:git_dir] + "/tosdr.org"
  command "/usr/bin/git pull"
end


# JustDeleteMe
git node[:tos_sources][:git_dir] + "/justdelete.me" do
  repository node[:tos_sources][:jdm_repo_url]
  reference "master"
  user  node[:tos_sources][:user]
  group node[:tos_sources][:group]
  action :checkout
end

cron "justdeleteme" do
  action :create
  minute "*/5"
  user node[:tos_sources][:user]
  mailto "morten@citizenme.com"
  home node[:tos_sources][:git_dir] + "/justdelete.me"
  command "/usr/bin/git pull"
end

# citizenme merged ToS content
git node[:tos_sources][:git_dir] + "/Content" do
  repository node[:tos_sources][:citizenme_tos_url]
  reference "master"
  user  node[:tos_sources][:user]
  group node[:tos_sources][:group]
  action :checkout
end

