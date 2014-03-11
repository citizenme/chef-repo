
default[:vertx][:version]     = '2.1RC1'
default[:vertx][:home_dir]    = '/usr/share/vertx'
default[:vertx][:conf_dir]    = '/usr/share/vertx/conf'
default[:vertx][:mods_dir]    = '/usr/share/vertx/mods'
default[:vertx][:release_url] = 'http://dl.bintray.com/vertx/downloads/vert.x-:version:.tar.gz'
default[:vertx][:log_dir] = '/var/log/vertx'

default[:vertx][:user]              = 'vertx'
default[:vertx][:group]             = 'vertx'
default[:users][:vertx][:uid]       = 2003
default[:groups][:vertx][:gid]      = 2003
default[:vertx][:pid_dir]           = '/home/vertx'

default[:vertx][:releases_url]      = 'maven:http://build.cloud.citizenme.com/nexus/content/repositories/releases'
default[:vertx][:snapshots_url]     = 'maven:http://build.cloud.citizenme.com/nexus/content/repositories/snapshots'

# Had to use a separate name for mods because data bag item names cannot contain special
# characters - like e.g. ~ from :mod
# data bag items are found as follows, meaning that multiple configurations can exist -
# one for each environment
# data_bag_item('vertx', node[:vertx][:mod_conf_name] ) [node.chef_environment] hash for environment specific configuration 

#default[:vertx][:mods]     = nil
default[:vertx][:supervisor_conf_dir] = '/etc/supervisor.d'

# To enable JMX add the following:
# "-Dcom.sun.management.jmxremote -Dvertx.management.jmx=true -Dhazelcast.jmx=true"

# multicast|tcp-ip|aws
default[:vertx][:network] = 'multicast'
default[:vertx][:multicast][:group] = '224.2.2.3'
default[:vertx][:multicast][:port]  = '54327'
# Array of IP addresses
default[:vertx][:tcpip][:addresses] = [ node[:ipaddress] ]
default[:vertx][:aws][:accesskey] = nil
default[:vertx][:aws][:secretkey] = nil
default[:vertx][:aws][:region] = nil
default[:vertx][:aws][:tagkey] = nil
default[:vertx][:aws][:tagvalue] = nil
default[:vertx][:interface] = node[:ipaddress]

default[:vertx][:logging][:level] = 'INFO'
default[:vertx][:hazelcast][:logging][:level] = 'INFO'
default[:vertx][:netty][:logging][:level] = 'SEVERE'

default[:vertx][:hazelcast][:appcluster] = false

