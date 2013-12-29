log_level                :info
log_location             STDOUT
node_name                'mjensen'
client_key               '/home/ubuntu/chef-repo/.chef/mjensen.pem'
validation_client_name   'chef-validator'
validation_key           '/home/ubuntu/chef-repo/.chef/chef-validator.pem'
chef_server_url          'https://ec2-54-194-51-0.eu-west-1.compute.amazonaws.com'
syntax_check_cache_path  '/home/ubuntu/chef-repo/.chef/syntax_check_cache'
cookbook_path [ '~/chef-repo/cookbooks' ]

