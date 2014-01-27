
default[:vertx][:version]     = '2.1M3'
default[:vertx][:home_dir]    = '/usr/share/vertx'
default[:vertx][:conf_dir]    = '/usr/share/vertx/conf'
default[:vertx][:mods_dir]    = '/usr/share/vertx/mods'
default[:vertx][:release_url] = 'http://dl.bintray.com/vertx/downloads/vert.x-:version:.tar.gz'
default[:vertx][:log_dir] = '/var/log/vertx'

default[:vertx][:user]              = 'vertx'
default[:vertx][:group]             = 'vertx'
default[:users][:vertx]             = 2003
default[:groups][:vertx]            = 2003

default[:vertx][:releases_url]      = 'maven:http://build.cloud.citizenme.com/nexus/content/repositories/releases'
default[:vertx][:snapshots_url]     = 'maven:http://build.cloud.citizenme.com/nexus/content/repositories/snapshots'

# default[:vertx][:mod] = 'com.citizenme~ToS-Load~0.1-SNAPSHOT'
default[:vertx][:mod] = ''

# Had to use a separate :mod_conf_name because data bag item names cannot contain special
# characters - like e.g. ~ from :mod
# data bag items are found as follows, meaning that multiple configurations can exist -
# one for each environment
# data_bag_item('vertx', node[:vertx][:mod_conf_name] ) [node.chef_environment] hash for environment specific configuration 
default[:vertx][:mod_conf_name]     = ''
default[:vertx][:supervisor_conf_dir] = '/etc/supervisor.d'
default[:vertx][:jvm_opts]          = '-Xms256m -Xmx256m -XX:MaxPermSize=96m -XX:+CMSClassUnloadingEnabled -XX:-UseGCOverheadLimit'

# To enable JMX add the following:
# "-Dcom.sun.management.jmxremote -Dvertx.management.jmx=true -Dhazelcast.jmx=true"
default[:vertx][:jmx_opts]          = ''

