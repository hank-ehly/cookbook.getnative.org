#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: dkim
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

include_recipe 'get-native.com-cookbook::postfix'

%w(opendkim opendkim-tools).each do |pkg|
    apt_package pkg
end

service 'opendkim' do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
end

directory "/etc/dkimkeys/#{node['get-native']['server_name']}" do
    recursive true
end

# todo: Extract string to variables or attributes
execute 'opendkim-genkey' do
    cwd "/etc/dkimkeys/#{node['get-native']['server_name']}"
    command "opendkim-genkey -t -s mail -d #{node['get-native']['server_name']}"
    creates "/etc/dkimkeys/#{node['get-native']['server_name']}/mail.private"
end

# todo: you ONLY want to edit permissions
file '/etc/dkimkeys/dkim.key' do
    mode 0600
    owner 'opendkim'
    group 'opendkim'
end

# todo: you ONLY want to edit permissions
file "/etc/dkimkeys/#{node['get-native']['server_name']}/mail.private" do
    mode 0600
    owner 'opendkim'
    group 'opendkim'
end

# todo: do you need to restart this much? does chef handle overlapping restart calls?
template '/etc/dkimkeys/dkim.key' do
    source 'dkim.key.erb'
    notifies :restart, 'service[opendkim]', :delayed
    notifies :restart, 'service[postfix]', :delayed
end

template '/etc/opendkim.conf' do
    source 'opendkim.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[opendkim]', :delayed
    notifies :restart, 'service[postfix]', :delayed
end

template '/etc/default/opendkim' do
    source 'opendkim.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[opendkim]', :delayed
    notifies :restart, 'service[postfix]', :delayed
end
