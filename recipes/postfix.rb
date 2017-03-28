#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: postfix
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

apt_package 'postfix'

template '/etc/postfix/main.cf' do
    source 'postfix.erb'
    owner 'root'
    group 'root'
    mode 0644
end

execute 'postalias' do
    command 'postalias /etc/aliases'
end

service 'postfix' do
    provider Chef::Provider::Service::Systemd
    action [:enable, :start]
end
