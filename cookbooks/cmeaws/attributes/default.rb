default[:cmeaws][:region] = "eu-west-1"
default[:cmeaws][:log_stream_prefix] = node['hostname']
default[:cmeaws][:log_group_name] = nil
default[:cmeaws][:log_type] = nil # "pdx", "api"
