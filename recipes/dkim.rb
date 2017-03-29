#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: dkim
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

opendkim_user  = 'opendkim'
opendkim_group = 'opendkim'
dkimkeys_root_dir  = '/etc/dkimkeys'
dkimkeys_contents_dir = "#{dkimkeys_root_dir}/#{node['get-native']['server_name']}"

include_recipe 'get-native.com-cookbook::postfix'

%w(opendkim opendkim-tools).each do |pkg|
    apt_package pkg
end

service 'opendkim' do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
end

directory dkimkeys_contents_dir do
    recursive true
end

execute 'opendkim-genkey' do
    cwd dkimkeys_contents_dir
    command "opendkim-genkey -t -s mail -d #{node['get-native']['server_name']}"
    creates "#{dkimkeys_contents_dir}/mail.private"
end

file '/etc/dkimkeys/dkim.key' do
    mode 0600
    owner opendkim_user
    group opendkim_group
end

file "#{dkimkeys_contents_dir}/mail.private" do
    mode 0600
    owner opendkim_user
    group opendkim_group
end

template "#{dkimkeys_root_dir}/dkim.key" do
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
