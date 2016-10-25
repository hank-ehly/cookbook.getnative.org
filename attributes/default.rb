default['get-native']['environment']['long'] = 'staging'
default['get-native']['environment']['short'] = 'stg'
default['get-native']['role'] = 'web'

default['get-native']['user']['name'] = 'get-native'
default['get-native']['user']['primary_group'] = 'get-native'
default['get-native']['user']['initial_password'] = 'get-native'
default['get-native']['user']['home'] = "/home/#{node['get-native']['user']['name']}"

default['get-native']['mysql']['version'] = '5.7'
default['get-native']['mysql']['initial_password'] = 'root'

default['apache']['listen'] = %w(*:80 *:443)
default['apache']['version'] = '2.4'
default['apache']['contact'] = 'henry.ehly@gmail.com'

default['nodejs']['bin_path'] = '/usr/local/nodejs-binary/bin'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '6.9.1'
default['nodejs']['binary']['checksum'] = 'a9d9e6308931fa2a2b0cada070516d45b76d752430c31c9198933c78f8d54b17'

default['authorization']['sudo']['include_sudoers_d'] = true
