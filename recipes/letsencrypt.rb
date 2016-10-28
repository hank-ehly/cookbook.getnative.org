#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: letsencrypt
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

if node['get-native']['environment'] != 'development'
    include_recipe 'acme'

    site = node['get-native']['server_name']

    acme_certificate node['get-native']['server_name'] do
        crt "#{node['apache']['dir']}/ssl/#{site}.crt"
        key "#{node['apache']['dir']}/ssl/#{site}.key"
        chain "#{node['apache']['dir']}/ssl/#{site}.pem"
        method 'http'
        owner 'root'
        group 'root'
        wwwroot node['get-native']['docroot']
        not_if { ::File.exists?("#{node['apache']['dir']}/ssl/#{site}.crt") }
    end
end

