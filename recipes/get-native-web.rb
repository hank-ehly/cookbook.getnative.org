#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: get-native-web
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

directory node['apache']['docroot_dir'] do
    user 'root'
    group 'root'
    mode 0755
end

directory '/var/www/get-native.com' do
    user node['get-native']['user']['name']
    group node['apache']['group']
    mode 0755
end

%W(#{node['get-native']['server_name']} www.#{node['get-native']['server_name']}).each do |domain|
    web_app domain do
        template "#{domain}.conf.erb"
        server_name domain
        docroot node['get-native']['docroot']
    end
end
