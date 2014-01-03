log_level                :info
log_location             STDOUT
node_name                'mjensen'
client_key               '/home/ubuntu/.chef/mjensen.pem'
validation_client_name   'chef-validator'
validation_key           '/home/ubuntu/.chef/chef-validator.pem'
chef_server_url          'https://chefserver.cloud.citizenme.com'
syntax_check_cache_path  '/home/ubuntu/.chef/syntax_check_cache'
cookbook_path [ '/home/ubuntu/chef-repo/cookbooks' ]
