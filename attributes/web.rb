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
default['nodejs']['version'] = '8.0.0'
default['nodejs']['binary']['checksum'] = '1944f0ead4c9dbdf92a97041cb2ec34cc08ea873958c7009befaa56a7ccea4c2'
