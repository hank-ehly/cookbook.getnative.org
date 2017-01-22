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

    domains = %W(#{node['get-native']['server_name']} www.#{node['get-native']['server_name']} api.#{node['get-native']['server_name']})
    web_cert_path = "#{node['apache']['dir']}/ssl/live/#{node['get-native']['server_name']}/fullchain.pem"
    api_cert_path = "#{node['apache']['dir']}/ssl/live/api.#{node['get-native']['server_name']}/fullchain.pem"
    certs_exist = File::exist?(web_cert_path) && File::exist?(api_cert_path)

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
                                 --apache-le-vhost-ext "-ssl.conf" \
                                 --redirect \
                                 --logs-dir #{node['apache']['log_dir']}
        EOH
        not_if certs_exist
    end
end
