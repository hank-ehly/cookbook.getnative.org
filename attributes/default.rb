default['getnative']['contact'] = 'admin@getnativelearning.com'
default['getnative']['user']['name'] = 'getnative'
default['getnative']['user']['primary_group'] = 'getnative'
default['getnative']['user']['initial_password'] = 'getnative'
default['getnative']['user']['shell'] = '/bin/bash'
default['getnative']['user']['home'] = "/home/#{node['getnative']['user']['name']}"
default['getnative']['mysql']['version'] = '5.7'
default['getnative']['mysql']['initial_password'] = 'root'

default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['permit_root_login'] = 'no'

default['authorization']['sudo']['include_sudoers_d'] = true
default['authorization']['sudo']['groups'] = []
