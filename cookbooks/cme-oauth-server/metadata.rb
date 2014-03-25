name             'cme-oauth-server'
maintainer       'citizenme'
maintainer_email 'info@citizenme.com'
license          'Apache 2.0'
description      'Installs/Configures cme-oauth-server'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'nginx',     '~> 2.4'
depends 'tomcat',    '~> 0.15'
