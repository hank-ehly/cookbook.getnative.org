default['apache']['listen'] = %w(*:80 *:443)
default['apache']['version'] = '2.4'
default['apache']['contact'] = node['getnative']['contact']
default['apache']['docroot_dir'] = '/var/www'
default['apache']['servertokens'] = 'Prod'
default['apache']['serversignature'] = 'Off'
default['apache']['timeout'] = 45

default['getnative']['is_prerelease'] = false
default['getnative']['prerelease_whitelist_ips'] = ['136.61.59.52']

default['nodejs']['bin_path'] = '/usr/local/nodejs-binary/bin'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '8.10.0'
default['nodejs']['binary']['checksum'] = 'c1302439aee9791d70d3ab4194a612e6131d37fa0e3452072e847e212ed77867'
