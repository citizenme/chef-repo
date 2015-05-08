
default[:pdx][:neo4j_version]           = "2.1.8"
default[:pdx][:neo4j_release_url]       = "http://dist.neo4j.org/neo4j-community-:neo4j_version:-unix.tar.gz"
default[:pdx][:neo4j_home_dir]          = '/usr/share/neo4j'
default[:pdx][:neo4j_db_dir]            = '/var/lib/neo4j/pdxuser'
default[:pdx][:neo4j_properties]        = "/var/lib/neo4j/pdxuser/neo4j.properties"
default[:pdx][:neo4j_server_properties] = "/var/lib/neo4j/pdxuser/neo4j-server.properties"
default[:pdx][:neo4j_http_log_config]   = "/var/lib/neo4j/pdxuser/neo4j-http-logging.xml"

default[:pdx][:cluster_type]            = "NONE" # AWS, NONE, SINGLE_NODE
default[:pdx][:neo4j_db_mode]		= "SINGLE" # SINGLE or HA
default[:pdx][:neo4j_cluster_port]	= "5001"
default[:pdx][:neo4j_http_address]	= "127.0.0.1"
default[:pdx][:neo4j_http_port]		= 7475

default[:pdx][:aws_region]              = nil
default[:pdx][:aws_cluster_tag_name]    = nil
default[:pdx][:aws_cluster_tag_value]   = nil
default[:pdx][:neo4j_ha_server_id]      = nil
default[:pdx][:neo4j_ha_initial_hosts]  = nil

