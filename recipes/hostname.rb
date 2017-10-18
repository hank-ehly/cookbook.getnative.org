#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: hostname
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

file '/etc/hostname' do
    content node['getnative']['server_name']
    group 'root'
    owner 'root'
    mode 0644
    notifies :run, 'execute[/etc/hostname]', :immediately
end

execute '/etc/hostname' do
    command 'hostname -F /etc/hostname'
    action :nothing
end
