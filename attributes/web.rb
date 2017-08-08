default['apache']['listen'] =  %w(*:80 *:443)
default['apache']['version'] = '2.4'
default['apache']['contact'] = node['getnative']['contact']
default['apache']['docroot_dir'] = '/var/www'
default['apache']['servertokens'] = 'Prod'
default['apache']['serversignature'] = 'Off'
default['apache']['timeout'] = 45

default['nodejs']['bin_path'] = '/usr/local/nodejs-binary/bin'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '8.1.0'
default['nodejs']['binary']['checksum'] = 'b53d6ad443f970d62a61d927bd28d63dcd2e19520e6e767bc6cc44f2cd8a4885'
