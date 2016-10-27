#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

if node['get-native']['environment'] == 'production' || 'staging'
    include_recipe 'acme'

    site = node['get-native']['domain']
    sans = Array[ "www.#{site}" ]

    acme_certificate node['get-native']['domain'] do
        crt "#{node['apache']['dir']}/ssl/#{site}.crt"
        key "#{node['apache']['dir']}/ssl/#{site}.key"
        chain "#{node['apache']['dir']}/ssl/#{site}.pem"
        method 'http'
        owner 'root'
        group 'root'
        wwwroot node['get-native']['docroot']
        alt_names sans
        notifies :restart, 'service[apache2]'
        not_if { ::File.exists?("#{node['apache']['dir']}/ssl/#{site}.crt") }
    end
end
