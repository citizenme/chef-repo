log_level                :info
log_location             STDOUT
node_name                'mjensen'
client_key               '/home/mjensen/.chef/mjensen.pem'
validation_client_name   'chef-validator'
validation_key           '/home/mjensen/.chef/chef-validator.pem'
chef_server_url          'https://chefserver.cloud.citizenme.com'
syntax_check_cache_path  '/home/mjensen/.chef/syntax_check_cache'
cookbook_path [ '/home/mjensen/development/git/chef-repo/cookbooks' ]
cookbook_copyright       "citizenme"
cookbook_email           "info@citizenme.com"
cookbook_license         "apachev2"

