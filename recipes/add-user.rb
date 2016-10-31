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

