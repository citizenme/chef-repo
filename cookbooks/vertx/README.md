vertx Cookbook
==============
Cookbook provides deployment recipes for Vert.X.

Requirements
------------

#### packages
- `install_from`

Attributes
----------
TODO: List you cookbook attributes here.

#### vertx::default
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

# E.g.
# default[:vertx][:mod] = 'com.citizenme~citizenme-service~0.1-SNAPSHOT'
default[:vertx][:mod] = ''

# data_bag_item('vertx', 'conf') with environment specific configuration
default[:vertx][:env] = 'development'

Usage
-----
#### vertx::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `vertx` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[vertx]"
  ]
}
```

License and Authors
-------------------
Authors:
- Morten Jensen, citizenme (morten@citizenme.com)

