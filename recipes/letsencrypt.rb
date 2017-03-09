#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

if node['get-native']['environment'] != 'development'
    apt_package 'python-letsencrypt-apache'

    cron 'letsencrypt' do
        command "/usr/bin/letsencrypt renew --config-dir #{node['apache']['dir']}/ssl --agree-tos --email #{node['get-native']['contact']}"
        minute '0'
        hour '0,12'
        user 'root'
        mailto node['get-native']['contact']
    end

    domains = %W(
        #{node['get-native']['server_name']}
        api.#{node['get-native']['server_name']}
        docs.#{node['get-native']['server_name']}
    )

    domains.each do |d|
        bash 'letsencrypt' do
            code <<-EOH
            /usr/bin/letsencrypt --domains #{domains.join(',')} \
                                 --apache \
                                 --agree-tos \
                                 --uir \
                                 --hsts \
                                 --non-interactive \
                                 --email #{node['get-native']['contact']} \
                                 --config-dir #{node['apache']['dir']}/ssl \
                                 --apache-server-root #{node['apache']['dir']} \
                                 --apache-vhost-root #{node['apache']['dir']}/sites-available \
                                 --apache-le-vhost-ext="-ssl.conf" \
                                 --redirect \
                                 --logs-dir #{node['apache']['log_dir']}
            EOH
            not_if { File::exist?("#{node['apache']['dir']}/ssl/live/#{d}/fullchain.pem") }
        end
    end
end
