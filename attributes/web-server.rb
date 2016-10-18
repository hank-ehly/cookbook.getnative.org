default['get-native']['environment'] = 'staging'

default['get-native']['user']['name'] = 'get_native'
default['get-native']['user']['primary_group'] = 'get_native'
default['get-native']['user']['initial_password'] = 'get_native'
default['get-native']['user']['home'] = "/home/#{node['get-native']['user']['name']}"
default['get-native']['mysql-version'] = '5.7'

default['apache']['listen'] = %w(*:80 *:443)
default['apache']['version'] = '2.4'
default['apache']['contact'] = 'henry.ehly@gmail.com'

default['nodejs']['bin_path'] = '/usr/local/nodejs-binary/bin'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '6.8.1'
default['nodejs']['binary']['checksum'] = '8d004e6990926508460495450a4083d40836e81710afca303d6a298e032c6b18'

default['authorization']['sudo']['include_sudoers_d'] = true
