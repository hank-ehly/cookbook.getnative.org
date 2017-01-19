#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: bootstrap
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'locale::default'
include_recipe 'openssh::default'

%w(git psmisc tree tmux cron-apt postfix).each do |pkg|
    apt_package pkg
end

template '/etc/cron-apt/config' do
    source 'cron-apt.erb'
    owner 'root'
    group 'root'
    mode 0644
end

template '/etc/postfix/main.cf' do
    source 'postfix.erb'
    owner 'root'
    group 'root'
    mode 0644
end

service 'postfix' do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
end
