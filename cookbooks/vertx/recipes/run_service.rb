
include_recipe "runit"

directory('/etc/sv/vertx/env'){ owner 'root' ; action :create ; recursive true }
runit_service "vertx" do
  options       node[:vertx]
end

