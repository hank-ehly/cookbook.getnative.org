#
# Cookbook Name:: cookbook.getnative.org
# Recipe:: authorized-keys
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

directory "#{node['getnative']['user']['home']}/.ssh" do
    mode '0700'
    owner node['getnative']['user']['name']
    group node['getnative']['user']['primary_group']
end

data_bag = "#{node['getnative']['environment']}-#{node['getnative']['role']}"

authorized_keys = ''
data_bag_item(data_bag, 'ssh')['authorized_keys'].each do |key|
    authorized_keys += "#{key}\n"
end

file 'authorized_keys' do
    path "#{node['getnative']['user']['home']}/.ssh/authorized_keys"
    content authorized_keys
    mode '0644'
    owner node['getnative']['user']['name']
    group node['getnative']['user']['primary_group']
end

