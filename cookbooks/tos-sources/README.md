tos-sources Cookbook
====================
Pulls in various git repositories to support citizenme ToS notification services - including ToS;DR and JustDelete.me

Requirements
------------

#### packages
- `git`

Attributes
----------

Defaults:

default[:tos_sources][:git_dir]          = '/var/lib/tos_sources/git'

default[:tos_sources][:user]              = 'vertx'
default[:tos_sources][:group]             = 'vertx'
default[:users][:tos_sources][:uid]       = 2003
default[:users][:tos_sources][:gid]       = 2003

default[:tos_sources][:tosdr_repo_url]    = 'https://github.com/tosdr/tosdr.org.git'
default[:tos_sources][:jdm_repo_url]      = 'https://github.com/rmlewisuk/justdelete.me.git'



Usage
-----

License and Authors
-------------------
Authors: 
- Morten Jensen, citizenme (morten@citizenme.com)

