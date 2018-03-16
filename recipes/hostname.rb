#
# Cookbook Name:: cookbook.getnative.org
# Recipe:: hostname
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

file '/etc/hostname' do
    content node['getnative']['domain']
    group 'root'
    owner 'root'
    mode 0644
    notifies :run, 'execute[/etc/hostname]', :immediately
end

execute '/etc/hostname' do
    command 'hostname -F /etc/hostname'
    action :nothing
end
