#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

if node['get-native']['environment'] == 'production' || 'staging'
    acme_certificate node['get-native']['domain'] do
        crt "#{node['apache']['dir']}/ssl/#{node['get-native']['domain']}.crt"
        key "#{node['apache']['dir']}/ssl/#{node['get-native']['domain']}.key"
        chain "#{node['apache']['dir']}/ssl/#{node['get-native']['domain']}.pem"
        method 'http'
        owner 'root'
        group 'root'
        wwwroot node['get-native']['docroot']
        notifies :restart, 'service[apache2]'
        not_if { ::File.exists?("#{node['apache']['dir']}/ssl/#{node['get-native']['domain']}.crt") }
    end
end
