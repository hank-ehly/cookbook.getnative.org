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

include_recipe 'sudo::default'

sudo node['get-native']['user']['name'] do
    user node['get-native']['user']['name']
    nopasswd true
end
