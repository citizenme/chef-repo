
default['java']['jdk_version'] = 7
default['java']['install_flavor'] = 'openjdk'

default['tomcat']['base_version']  = 7
default['tomcat']['port']          = 10180
default['tomcat']['ajp_port']      = 10181
default['tomcat']['java_options']  = '-Xms160M -Xmx160M -XX:MaxPermSize=80m -XX:+CMSClassUnloadingEnabled -XX:+PrintGCDetails -XX:+PrintGCDateStamps'
default['tomcat']['max_threads']   = 64

default['tomcat']['app_conf_dir'] = node['tomcat']['base'] + "/appconf"
