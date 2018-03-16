#
# Cookbook Name:: cookbook.getnative.org
# Recipe:: dkim
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

opendkim_user  = 'opendkim'
opendkim_group = 'opendkim'
dkimkeys_root_dir  = '/etc/dkimkeys'
dkimkeys_contents_dir = "#{dkimkeys_root_dir}/#{node['getnative']['server_name']}"

include_recipe 'cookbook.getnative.org::postfix'

%w(opendkim opendkim-tools).each do |pkg|
    apt_package pkg
end

directory dkimkeys_contents_dir do
    owner opendkim_user
    group opendkim_group
    mode 0755
    recursive true
end

directory '/var/log/dkim-filter' do
    mode 0700
    owner opendkim_user
    group opendkim_group
end

execute 'opendkim-genkey' do
    cwd dkimkeys_contents_dir
    command "opendkim-genkey -t -s mail -d #{node['getnative']['server_name']}"
    creates "#{dkimkeys_contents_dir}/mail.private"
end

file "#{dkimkeys_contents_dir}/mail.private" do
    mode 0600
    owner opendkim_user
    group opendkim_group
end

link "#{dkimkeys_root_dir}/dkim.key" do
    to "#{dkimkeys_contents_dir}/mail.private"
    owner opendkim_user
    group opendkim_group
    notifies :restart, 'service[opendkim]', :delayed
    notifies :restart, 'service[postfix]', :delayed
end

template '/etc/opendkim.conf' do
    source 'dkim/opendkim.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[opendkim]', :delayed
    notifies :restart, 'service[postfix]', :delayed
end

template '/etc/default/opendkim' do
    source 'dkim/opendkim.erb'
    owner 'root'
    group 'root'
    mode 0644
    notifies :restart, 'service[opendkim]', :delayed
    notifies :restart, 'service[postfix]', :delayed
end

service 'opendkim' do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
end
