#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: db-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

return if node['platform_family'] != 'debian'

apt_update 'update-packages' do
    action :update
end

group node['get-native']['user']['primary_group']

user node['get-native']['user']['name'] do
    group node['get-native']['user']['primary_group']
    home node['get-native']['user']['home']
    manage_home true
    password node['get-native']['user']['initial_password']
end

include_recipe 'sudo::default'

sudo node['get-native']['user']['primary_group'] do
    group node['get-native']['user']['primary_group']
    nopasswd true
    commands node['get-native']['user']['sudo_commands']
end

directory "#{node['get-native']['user']['home']}/.ssh" do
    mode '0700'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end

file 'authorized_keys' do
    path "#{node['get-native']['user']['home']}/.ssh/authorized_keys"
    content data_bag_item(node['get-native']['user']['name'], 'public_key')['public_key']
    mode '0644'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end

include_recipe 'build-essential::default'
include_recipe 'locale::default'

%w(psmisc tree).each do |pkg|
    apt_package pkg
end

include_recipe 'build-essential::default'

mysql_service 'get-native' do
    version node['get-native']['mysql-version']
    initial_root_password 'root'
    bind_address '0.0.0.0'
    charset 'utf8'
    run_group 'mysql'
    run_user 'mysql'
    port 3306
    notifies :run, 'execute[upgrade]', :before
    action [:create, :start]
end

bash 'init-db' do
    code <<-EOH
        mysql -u root \
              --password=ilikerandompasswords \
              -S /var/run/mysql-get-native/mysqld.sock \
              -e 'CREATE DATABASE IF NOT EXISTS get_native DEFAULT CHARACTER SET UTF8;'
    EOH
end
