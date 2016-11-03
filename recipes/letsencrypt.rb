#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

if node['get-native']['environment'] != 'development'
    apt_package 'python-letsencrypt-apache'

    cron 'letsencrypt' do
        command "if [[ `which letsencrypt` ]] ; then letsencrypt renew --config-dir #{node['apache']['dir']}/ssl --agree-tos --email #{node['get-native']['contact']} --quiet ; fi"
        minute '0'
        hour '0,12'
        user 'root'
        mailto node['get-native']['contact']
    end

    domains = %W(#{node['get-native']['server_name']} www.#{node['get-native']['server_name']})

    bash 'letsencrypt' do
        code <<-EOH
            /usr/bin/letsencrypt --domains #{domains.join(',')} \
                                 --apache \
                                 --agree-tos \
                                 --non-interactive \
                                 --email #{node['get-native']['contact']} \
                                 --config-dir #{node['apache']['dir']}/ssl \
                                 --apache-server-root #{node['apache']['dir']} \
                                 --apache-vhost-root #{node['apache']['dir']}/sites-available \
                                 --redirect \
                                 --logs-dir #{node['apache']['log_dir']}
        EOH
        not_if { ! ::File.exists?('/usr/bin/letsencrypt') }
    end
end

