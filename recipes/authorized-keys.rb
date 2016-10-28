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

data_bag = "#{node['get-native']['environment']}-#{node['get-native']['role']}"

authorized_keys = ''
data_bag_item(data_bag, 'ssh')['authorized_keys'].each do |key|
    authorized_keys += "#{key}\n"
end

file 'authorized_keys' do
    path "#{node['get-native']['user']['home']}/.ssh/authorized_keys"
    content authorized_keys
    mode '0644'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end
