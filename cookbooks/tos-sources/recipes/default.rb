#
# Cookbook Name:: tos_sources
# Recipe:: default
#
# Copyright 2014, citizenme
#
# All rights reserved _ Do Not Redistribute
#

include_recipe 'git'

directory node[:tos_sources][:git_dir] do
  owner node[:tos_sources][:user]
  group node[:tos_sources][:group]
  recursive true
  action :create
end

# ToS;DR
git node[:tos_sources][:git_dir] do
  repository node[:tos_sources][:tosdr_repo_url]
  reference "master"
  action :checkout
end

# JustDeleteMe
git node[:tos_sources][:git_dir] do
  repository node[:tos_sources][:jdm_repo_url]
  reference "master"
  action :checkout
end

