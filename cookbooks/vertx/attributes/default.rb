
default[:vertx][:version]     = '2.1M3'
default[:vertx][:home_dir]    = '/usr/share/vertx'
default[:vertx][:conf_dir]    = '/usr/share/vertx/conf'
default[:vertx][:mods_dir]    = '/usr/share/vertx/mods'
default[:vertx][:release_url] = 'http://dl.bintray.com/vertx/downloads/vert.x-:version:.tar.gz'
default[:vertx][:log_dir] = '/var/log/vertx'

default[:vertx][:user]              = 'vertx'
default[:vertx][:group]             = 'vertx'
default[:users][:vertx][:uid]       = 2003
default[:users][:vertx][:gid]       = 2003

default[:vertx][:releases_url]      = 'maven:http://build.cloud.citizenme.com/nexus/content/repositories/releases'
default[:vertx][:snapshots_url]     = 'maven:http://build.cloud.citizenme.com/nexus/content/repositories/snapshots'

# default[:vertx][:mod] = 'com.citizenme~ToS-Load~0.1-SNAPSHOT'
default[:vertx][:mod] = ''

# data_bag_item('vertx', node[:vertx][:mod_conf_name] ) [node.chef_environment] hash for environment specific configuration 
# Resulting configuration file is also named "#{node[:vertx][:mod_conf_name]}.conf"
default[:vertx][:mod_conf_name]     = ''
default[:vertx][:supervisor_conf_dir] = '/etc/supervisor.d'
