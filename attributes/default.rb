default['get-native']['contact'] = 'admin@get-native.com'
default['get-native']['user']['name'] = 'get-native'
default['get-native']['user']['primary_group'] = 'get-native'
default['get-native']['user']['initial_password'] = 'get-native'
default['get-native']['user']['shell'] = '/bin/bash'
default['get-native']['user']['home'] = "/home/#{node['get-native']['user']['name']}"
default['get-native']['mysql']['version'] = '5.7'
default['get-native']['mysql']['initial_password'] = 'root'

default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['permit_root_login'] = 'no'

default['authorization']['sudo']['include_sudoers_d'] = true
default['authorization']['sudo']['groups'] = []
