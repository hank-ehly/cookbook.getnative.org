#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: add-user
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

group node['get-native']['user']['primary_group']

user node['get-native']['user']['name'] do
    group node['get-native']['user']['primary_group']
    home node['get-native']['user']['home']
    manage_home true
    password node['get-native']['user']['initial_password']
    shell node['get-native']['user']['shell']
end

%w(git psmisc tree screen).each do |pkg|
    apt_package pkg
end

template '~/.screenrc' do
    source 'screenrc.erb'
    path "#{node['get-native']['user']['home']}/.screenrc"
    mode '0644'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end

include_recipe 'sudo::default'

sudo node['get-native']['user']['primary_group'] do
    group node['get-native']['user']['primary_group']
    nopasswd true
    commands node['get-native']['user']['sudo_commands']
end

directory node['get-native']['local-log-dir']

cron 'network-usage'
    minute '0'
    hour '0'
    user 'root'
    mailto node['get-native']['contact']
    command %W{
        /bin/echo \"* `date`\" && 
        iptables -S -Z -v |
        /usr/bin/awk '/^-P/{ print $2, $6 }' |
        /usr/bin/tr ' ' '\t' > #{node['get-native']['local-log-dir']}/network-usage.log 2>&1
    }.join(' ')
end

