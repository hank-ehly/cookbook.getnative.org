#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: add-user
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

group node['getnative']['user']['primary_group']

user node['getnative']['user']['name'] do
    group node['getnative']['user']['primary_group']
    home node['getnative']['user']['home']
    manage_home true
    password node['getnative']['user']['initial_password']
    shell node['getnative']['user']['shell']
end

include_recipe 'sudo::default'

sudo node['getnative']['user']['name'] do
    user node['getnative']['user']['name']
    runas 'ALL:ALL'
    nopasswd true
end

if ENV['CI']
    db_credentials = {
        getnative_password: 'dummy-password'
    }
else
    db_credentials = data_bag_item("#{node['getnative']['environment']}-#{node['getnative']['role']}", 'db-credentials')
end

template 'getnative user .bashrc' do
    source 'add-user/getnative-bashrc.erb'
    path "#{node['getnative']['user']['home']}/.bashrc"
    mode 0644
    owner node['getnative']['user']['name']
    group node['getnative']['user']['primary_group']
    variables({
        getnative_db_password: db_credentials['getnative_password'],
        node_env: node['getnative']['environment']
    })
end

template 'root user .bashrc' do
    source 'add-user/root-bashrc.erb'
    path '/root/.bashrc'
    mode 0644
    owner 'root'
    group 'root'
    variables({
        getnative_db_password: db_credentials['getnative_password'],
        node_env: node['getnative']['environment']
    })
end
