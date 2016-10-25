#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: authorized-keys
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

directory "#{node['get-native']['user']['home']}/.ssh" do
    mode '0700'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end

data_bag = "#{node['get-native']['environment']['short']}-#{node['get-native']['role']}"

# TODO: DB or WEB
# node.default['get-native']['data_bag'] = 'stg-web-get-native-com' if node['get-native']['data_bag'].nil? || node['get-native']['data_bag'].empty?

file 'authorized_keys' do
    path "#{node['get-native']['user']['home']}/.ssh/authorized_keys"
    content data_bag_item(data_bag, 'public_key')['public_key']
    mode '0644'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end
