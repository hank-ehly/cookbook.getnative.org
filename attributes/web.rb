default['apache']['listen'] =  %w(*:80 *:443)
default['apache']['version'] = '2.4'
default['apache']['contact'] = node['get-native']['contact']
default['apache']['docroot_dir'] = '/var/www'
default['apache']['servertokens'] = 'Prod'
default['apache']['serversignature'] = 'Off'
default['apache']['timeout'] = 45

default['get-native']['docroot'] = "#{node['apache']['docroot_dir']}/get-native.com/current/dist/prod"
default['get-native']['github']['repo'] = 'hank-ehly/get-native.com'
default['get-native']['user']['sudo_commands'] = %w(/usr/sbin/apachectl /usr/sbin/apache2 /usr/local/bin/node /usr/local/bin/npm /sbin/iptables /usr/bin/mkdocs)

default['nodejs']['bin_path'] = '/usr/local/nodejs-binary/bin'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '6.10.1'
default['nodejs']['binary']['checksum'] = 'e8f100e9ee70eb63216b33cf39666a4dc6c4038f6ee4fbfc7751ab3a825e576c'
