
default[:vertx][:version]     = '2.1M3'
default[:vertx][:home_dir]    = '/usr/share/vertx'
default[:vertx][:mods_dir]    = '/usr/share/vertx/mods'
default[:vertx][:release_url] = 'http://dl.bintray.com/vertx/downloads/vert.x-:version:.tar.gz'
default[:vertx][:log_dir] = '/var/log/vertx'

default[:vertx][:user]              = 'vertx'
default[:vertx][:group]             = 'vertx'
default[:users][:vertx][:uid]       = 2003
default[:users][:vertx][:gid]       = 2003

default[:vertx][:releases_url]      = 'maven:https://build.cloud.citizenme.com/nexus/content/repositories/releases'
default[:vertx][:snapshots_url]     = 'maven:https://build.cloud.citizenme.com/nexus/content/repositories/snapshots'

default[:vertx][:mod] = 'com.citizenme~citizenme-service~0.1-SNAPSHOT'

# data_bag_item('vertx', 'conf') with environment specific configuration
default[:vertx][:env] = 'production'

