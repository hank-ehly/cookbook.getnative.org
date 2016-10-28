if node['get-native']['environment'] == 'production'
    default['acme']['endpoint'] = 'https://acme-v01.api.letsencrypt.org'
elsif node['get-native']['environment'] == 'staging'
    default['acme']['endpoint'] = 'https://acme-staging.api.letsencrypt.org'
end

default['acme']['contact'] = ['mailto:henry.ehly@gmail.com']
default['acme']['renew'] = 30

default['apache']['listen'] =  %w(*:80 *:443)
default['apache']['version'] = '2.4'
default['apache']['contact'] = 'henry.ehly@gmail.com'

default['get-native']['docroot'] = "/var/www/get-native.com/#{node['get-native']['environment']}/current/dist/prod"
default['get-native']['github']['repo'] = 'hank-ehly/get-native.com'
default['get-native']['user']['sudo_commands'] = [
        '/usr/sbin/apachectl',
        '/usr/sbin/apache2',
        '/usr/local/bin/node',
        '/sbin/iptables'
]

default['nodejs']['bin_path'] = '/usr/local/nodejs-binary/bin'
default['nodejs']['install_method'] = 'binary'
default['nodejs']['version'] = '6.9.1'
default['nodejs']['binary']['checksum'] = 'a9d9e6308931fa2a2b0cada070516d45b76d752430c31c9198933c78f8d54b17'
