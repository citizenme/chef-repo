log_level                :info
log_location             STDOUT
node_name                'citizenme'
client_key               '/home/citizenme/chef-repo/.chef/citizenme.pem'
validation_client_name   'chef-validator'
validation_key           '/home/citizenme/chef-repo/.chef/chef-validator.pem'
chef_server_url          'https://mgmt.internal.virtuability.com'
syntax_check_cache_path  '/home/citizenme/chef-repo/.chef/syntax_check_cache'
cookbook_path [ '/home/citizenme/chef-repo/cookbooks' ]
