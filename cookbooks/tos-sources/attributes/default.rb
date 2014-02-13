
default[:tos_sources][:git_dir]          = '/var/lib/tos_sources/git'

default[:tos_sources][:user]              = 'vertx'
default[:tos_sources][:group]             = 'vertx'
default[:tos_sources][:pid_dir]           = '/home/vertx'

default[:tos_sources][:tosdr_repo_url]    = 'git@github.com:tosdr/tosdr.org.git'
default[:tos_sources][:jdm_repo_url]      = 'git@github.com:rmlewisuk/justdelete.me.git'
default[:tos_sources][:citizenme_tos_url]     = 'git@github.com:citizenme/Content.git'
default[:tos_sources][:citizenme_tosload_url] = 'git@github.com:citizenme/External-Content.git'

default[:tos_sources][:tosdr_branch]      = 'master'
default[:tos_sources][:jdm_branch]        = 'master'
default[:tos_sources][:citizenme_tos_branch] = 'vm-dev'
default[:tos_sources][:citizenme_tosload_branch] = 'vm-dev'
