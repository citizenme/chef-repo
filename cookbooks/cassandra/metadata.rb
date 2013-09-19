maintainer       "Benjamin Black"
maintainer_email "b@b3k.us"
license          "Apache 2.0"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.4"

description      "Cassandra: a massively scalable high-performance distributed storage system"

depends          "java"
depends          "apt"
depends          "runit"
depends          "thrift"
depends          "iptables"
depends          "volumes"
depends          "metachef"
depends          "install_from"

recipe           "cassandra::autoconf",                "Automatically configure nodes from chef-server information."
recipe           "cassandra::ec2snitch",               "Automatically configure properties snitch for clusters on EC2."
recipe           "cassandra::iptables",                "Automatically configure iptables rules for cassandra."
recipe           "cassandra::authentication",          "Authentication"
recipe           "cassandra::bintools",                "Bintools"
recipe           "cassandra::client",                  "Client"
recipe           "cassandra::default",                 "Base configuration for cassandra"
recipe           "cassandra::install_from_git",        "Install From Git"
recipe           "cassandra::install_from_package",    "Install From Package"
recipe           "cassandra::install_from_release",    "Install From Release"
recipe           "cassandra::jna_support",             "Jna Support"
recipe           "cassandra::mx4j",                    "Mx4j"
recipe           "cassandra::server",                  "Server"
recipe           "cassandra::ruby_client",             "support gems for cassandra (incl. fauna/cassandra and apache/avro)"

%w[ debian ubuntu ].each do |os|
  supports os
end

attribute "cassandra/cluster_name",
  :display_name          => "Cassandra cluster name",
  :description           => "The name for the Cassandra cluster in which this node should participate.  The default is 'Test Cluster'.",
  :default               => "cluster_name"

attribute "cassandra/home_dir",
  :display_name          => "",
  :description           => "Directories, hosts and ports        # =",
  :default               => "/usr/local/share/cassandra"

attribute "cassandra/conf_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/etc/cassandra"

attribute "cassandra/commitlog_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/mnt/cassandra/commitlog"

attribute "cassandra/data_dirs",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["/data/db/cassandra"]

attribute "cassandra/saved_caches_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/lib/cassandra/saved_caches"

attribute "cassandra/user",
  :display_name          => "cassandra",
  :description           => "The cassandra user",
  :default               => "cassandra"

attribute "cassandra/listen_addr",
  :display_name          => "",
  :description           => "",
  :default               => "localhost"

attribute "cassandra/seeds",
  :display_name          => "",
  :description           => "",
  :type                  => "array",
  :default               => ["127.0.0.1"]

attribute "cassandra/rpc_addr",
  :display_name          => "",
  :description           => "",
  :default               => "localhost"

attribute "cassandra/rpc_port",
  :display_name          => "",
  :description           => "",
  :default               => "9160"

attribute "cassandra/storage_port",
  :display_name          => "",
  :description           => "",
  :default               => "7000"

attribute "cassandra/jmx_dash_port",
  :display_name          => "",
  :description           => "",
  :default               => "12345"

attribute "cassandra/mx4j_port",
  :display_name          => "",
  :description           => "",
  :default               => "8081"

attribute "cassandra/mx4j_addr",
  :display_name          => "",
  :description           => "",
  :default               => "127.0.0.1"

attribute "cassandra/release_url",
  :display_name          => "",
  :description           => "install_from_release: tarball url",
  :default               => ":apache_mirror:/cassandra/:version:/apache-cassandra-:version:-bin.tar.gz"

attribute "cassandra/git_repo",
  :display_name          => "",
  :description           => "Git repo location",
  :default               => "git://git.apache.org/cassandra.git"

attribute "cassandra/git_revision",
  :display_name          => "",
  :description           => "until ruby gem is updated, use cdd239dcf82ab52cb840e070fc01135efb512799",
  :default               => "cdd239dcf82ab52cb840e070fc01135efb512799"

attribute "cassandra/jna_deb_amd64_url",
  :display_name          => "",
  :description           => "JNA deb location",
  :default               => "http://debian.riptano.com/maverick/pool/libjna-java_3.2.7-0~nmu.2_amd64.deb"

attribute "cassandra/auto_bootstrap",
  :display_name          => "Cassandra automatic boostrap boolean",
  :description           => "Boolean indicating whether a node should automatically boostrap on startup.",
  :default               => "false"

attribute "cassandra/keyspaces",
  :display_name          => "Cassandra keyspaces",
  :description           => "Make a databag called 'cassandra', with an element 'clusters'. Within that, define a hash named for your cluster:\n\n- keys_cached:        specifies the number of keys per sstable whose locations we keep in memory in \"mostly LRU\" order.  (JUST the key locations, NOT any column values.) Specify a fraction (value less than 1) or an absolute number of keys to cache.  Defaults to 200000 keys.\n- rows_cached:        specifies the number of rows whose entire contents we cache in memory. Do not use this on ColumnFamilies with large rows, or ColumnFamilies with high write:read ratios. Specify a fraction (value less than 1) or an absolute number of rows to cache. Defaults to 0. (i.e. row caching is off by default)\n- comment:            used to attach additional human-readable information about the column family to its definition.\n- read_repair_chance: specifies the probability with which read repairs should be invoked on non-quorum reads.  must be between 0 and 1. defaults to 1.0 (always read repair).\n- preload_row_cache:  If true, will populate row cache on startup. Defaults to false.\n- gc_grace_seconds:   specifies the time to wait before garbage collecting tombstones (deletion markers). defaults to 864000 (10 days). See http://wiki.apache.org/cassandra/DistributedDeletes\n",
  :type                  => "array",
  :default               => ""

attribute "cassandra/authenticator",
  :display_name          => "Cassandra authenticator",
  :description           => "The IAuthenticator to be used for access control.",
  :default               => "org.apache.cassandra.auth.AllowAllAuthenticator"

attribute "cassandra/partitioner",
  :display_name          => "",
  :description           => "",
  :default               => "org.apache.cassandra.dht.RandomPartitioner"

attribute "cassandra/initial_token",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "cassandra/commitlog_rotation_threshold",
  :display_name          => "",
  :description           => "",
  :default               => "128"

attribute "cassandra/thrift_framed_transport",
  :display_name          => "",
  :description           => "",
  :default               => "15"

attribute "cassandra/disk_access_mode",
  :display_name          => "",
  :description           => "",
  :default               => "auto"

attribute "cassandra/sliced_buffer_size",
  :display_name          => "",
  :description           => "",
  :default               => "64"

attribute "cassandra/column_index_size",
  :display_name          => "",
  :description           => "",
  :default               => "64"

attribute "cassandra/memtable_throughput",
  :display_name          => "",
  :description           => "",
  :default               => "64"

attribute "cassandra/memtable_ops",
  :display_name          => "",
  :description           => "",
  :default               => "0.3"

attribute "cassandra/memtable_flush_after",
  :display_name          => "",
  :description           => "",
  :default               => "60"

attribute "cassandra/concurrent_reads",
  :display_name          => "",
  :description           => "",
  :default               => "8"

attribute "cassandra/concurrent_writes",
  :display_name          => "",
  :description           => "",
  :default               => "32"

attribute "cassandra/commitlog_sync",
  :display_name          => "",
  :description           => "",
  :default               => "periodic"

attribute "cassandra/commitlog_sync_period",
  :display_name          => "",
  :description           => "",
  :default               => "10000"

attribute "cassandra/authority",
  :display_name          => "",
  :description           => "",
  :default               => "org.apache.cassandra.auth.AllowAllAuthority"

attribute "cassandra/hinted_handoff_enabled",
  :display_name          => "",
  :description           => "",
  :default               => "true"

attribute "cassandra/max_hint_window_in_ms",
  :display_name          => "",
  :description           => "",
  :default               => "3600000"

attribute "cassandra/hinted_handoff_delay_ms",
  :display_name          => "",
  :description           => "",
  :default               => "50"

attribute "cassandra/endpoint_snitch",
  :display_name          => "",
  :description           => "",
  :default               => "org.apache.cassandra.locator.SimpleSnitch"

attribute "cassandra/dynamic_snitch",
  :display_name          => "",
  :description           => "",
  :default               => "true"

attribute "cassandra/java_heap_size_min",
  :display_name          => "",
  :description           => "",
  :default               => "128M"

attribute "cassandra/java_heap_size_max",
  :display_name          => "",
  :description           => "",
  :default               => "1650M"

attribute "cassandra/java_heap_size_eden",
  :display_name          => "",
  :description           => "",
  :default               => "1500M"

attribute "cassandra/memtable_flush_writers",
  :display_name          => "",
  :description           => "",
  :default               => "1"

attribute "cassandra/thrift_max_message_length",
  :display_name          => "",
  :description           => "",
  :default               => "16"

attribute "cassandra/incremental_backups",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "cassandra/snapshot_before_compaction",
  :display_name          => "",
  :description           => "",
  :default               => ""

attribute "cassandra/in_memory_compaction_limit",
  :display_name          => "",
  :description           => "",
  :default               => "64"

attribute "cassandra/compaction_preheat_key_cache",
  :display_name          => "",
  :description           => "",
  :default               => "true"

attribute "cassandra/flush_largest_memtables_at",
  :display_name          => "",
  :description           => "",
  :default               => "0.75"

attribute "cassandra/reduce_cache_sizes_at",
  :display_name          => "",
  :description           => "",
  :default               => "0.85"

attribute "cassandra/reduce_cache_capacity_to",
  :display_name          => "",
  :description           => "",
  :default               => "0.6"

attribute "cassandra/rpc_timeout_in_ms",
  :display_name          => "",
  :description           => "",
  :default               => "10000"

attribute "cassandra/rpc_keepalive",
  :display_name          => "",
  :description           => "",
  :default               => "false"

attribute "cassandra/phi_convict_threshold",
  :display_name          => "",
  :description           => "",
  :default               => "8"

attribute "cassandra/request_scheduler",
  :display_name          => "",
  :description           => "",
  :default               => "org.apache.cassandra.scheduler.NoScheduler"

attribute "cassandra/throttle_limit",
  :display_name          => "",
  :description           => "",
  :default               => "80"

attribute "cassandra/request_scheduler_id",
  :display_name          => "",
  :description           => "",
  :default               => "keyspace"

attribute "cassandra/log_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/log/cassandra"

attribute "cassandra/lib_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/lib/cassandra"

attribute "cassandra/pid_dir",
  :display_name          => "",
  :description           => "",
  :default               => "/var/run/cassandra"

attribute "cassandra/group",
  :display_name          => "nogroup",
  :description           => "The group that cassandra belongs to",
  :default               => "nogroup"

attribute "cassandra/version",
  :display_name          => "",
  :description           => "install_from_release",
  :default               => "0.7.10"

attribute "cassandra/mx4j_version",
  :display_name          => "",
  :description           => "MX4J Version",
  :default               => "3.0.2"

attribute "cassandra/mx4j_release_url",
  :display_name          => "",
  :description           => "MX4J location (at least as of Version 3.0.2)",
  :default               => "http://downloads.sourceforge.net/project/mx4j/MX4J%20Binary/x.x/mx4j-x.x.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fmx4j%2Ffiles%2F&ts=1303407638&use_mirror=iweb"

attribute "users/cassandra/uid",
  :display_name          => "",
  :description           => "",
  :default               => "330"

attribute "users/cassandra/gid",
  :display_name          => "",
  :description           => "",
  :default               => "330"

attribute "tuning/ulimit/cassandra",
  :display_name          => "",
  :description           => "",
  :type                  => "hash",
  :default               => {:nofile=>{:both=>32768}, :nproc=>{:both=>50000}}
