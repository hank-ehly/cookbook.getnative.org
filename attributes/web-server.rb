default['apache']['listen'] =  %w(*:80 *:443)
default['apache']['version'] = '2.4'
default['apache']['contact'] = node['get-native']['contact']
default['apache']['docroot_dir'] = '/var/www'
# default['apache']['default_release'] = (Todo: Specify apache2=2.4.25-0.0+deb.sury.org~xenial+1 somehow)

default['get-native']['docroot'] = "#{node['apache']['docroot_dir']}/get-native.com/#{node['get-native']['environment']}/current/dist/prod"
default['get-native']['github']['repo'] = 'hank-ehly/get-native.com'
default['get-native']['user']['sudo_commands'] = %w(/usr/sbin/apachectl /usr/sbin/apache2 /usr/local/bin/node /usr/local/bin/npm /sbin/iptables)
default['get-native']['ip-whitelist'] = %w(124.144 124.145 61.206.117.242 153.205.74.244 180.43.58.102 136.61.59.52 118.8.132.92 68.45.149.102 118.238.203.216 127.0.0.1)

default['nodejs']['bin_path'] = '/usr/local/nodejs-binary/bin'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '6.9.4'
default['nodejs']['binary']['checksum'] = 'a1faed4afbbdbdddeae17a24b873b5d6b13950c36fabcb86327a001d24316ffb'
