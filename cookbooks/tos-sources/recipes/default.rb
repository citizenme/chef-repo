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

directory node[:tos_sources][:git_dir] do
  owner node[:tos_sources][:user]
  group node[:tos_sources][:group]
  recursive true
  action :create
end

# With ToS-Load gone none of this is needed anymore
# ToS;DR
#git node[:tos_sources][:git_dir] + "/tosdr.org" do
#  repository node[:tos_sources][:tosdr_repo_url]
#  reference node[:tos_sources][:tosdr_branch]
#  user  node[:tos_sources][:user]
#  group node[:tos_sources][:group]
#  action :checkout
#end

#cron "tosdr" do
#  action :create
#  minute "*/5"
#  user node[:tos_sources][:user]
#  mailto "service@citizenme.com"
#  command "cd #{node[:tos_sources][:git_dir]}/tosdr.org ; /usr/bin/git checkout #{node[:tos_sources][:tosdr_branch]} ; /usr/bin/git pull"
#end


# JustDeleteMe
#git node[:tos_sources][:git_dir] + "/justdelete.me" do
#  repository node[:tos_sources][:jdm_repo_url]
#  reference node[:tos_sources][:jdm_branch]
#  user  node[:tos_sources][:user]
#  group node[:tos_sources][:group]
#  action :checkout
#end

#cron "justdeleteme" do
#  action :create
#  minute "*/5"
#  user node[:tos_sources][:user]
#  mailto "service@citizenme.com"
#  home node[:tos_sources][:git_dir] + "/justdelete.me"
#  command "cd #{node[:tos_sources][:git_dir]}/justdelete.me ; /usr/bin/git checkout #{node[:tos_sources][:tosdr_branch]} ; /usr/bin/git pull"
#end

# citizenme merged ToS-Load content
#git node[:tos_sources][:git_dir] + "/External-Content" do
#  repository node[:tos_sources][:citizenme_tosload_url]
#  reference node[:tos_sources][:citizenme_tosload_branch]
#  user  node[:tos_sources][:user]
#  group node[:tos_sources][:group]
#  action :checkout
#end

# citizenme merged ToS content
git node[:tos_sources][:git_dir] + "/Content" do
  repository node[:tos_sources][:citizenme_tos_url]
  reference node[:tos_sources][:citizenme_tos_branch]
  user  node[:tos_sources][:user]
  group node[:tos_sources][:group]
  action :checkout
end

