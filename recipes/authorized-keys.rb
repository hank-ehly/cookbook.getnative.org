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

cookbook_file 'authorized_keys' do
    path "#{node['get-native']['user']['home']}/.ssh/authorized_keys"
    source 'authorized_keys'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    mode '0644'
end
