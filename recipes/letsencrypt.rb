#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

if node['get-native']['environment'] != 'development'
    apt_package 'python-letsencrypt-apache'

    cron 'letsencrypt' do
        command 'if [[ `which /usr/bin/letsencrypt` ]]; then /usr/bin/letsencrypt renew --quiet ; fi'
        minute '0'
        hour '0,12'
        user node['get-native']['user']['name']
        mailto node['get-native']['contact']
    end

    domains = %W(#{node['get-native']['server_name']} www.#{node['get-native']['server_name']})

    bash 'letsencrypt' do
        code <<-EOH
            /usr/bin/letsencrypt -d #{domains.join(' ')} \
                                 --apache \
                                 --agree-tos \
                                 --non-interactive \
                                 --email #{node['get-native']['contact']} \
                                 --cert-path #{node['apache']['dir']}/ssl/#{node['get-native']['server_name']}/cert.pem \
                                 --key-path #{node['apache']['dir']}/ssl/#{node['get-native']['server_name']}/privkey.pem \
                                 --chain-path #{node['apache']['dir']}/ssl/#{node['get-native']['server_name']}/chain.pem \
                                 --config-dir #{node['apache']['dir']}
        EOH
    end
end

