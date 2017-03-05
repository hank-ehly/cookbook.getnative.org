#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: mysql-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

mysql_service 'get-native' do
    version node['get-native']['mysql']['version']
    initial_root_password node['get-native']['mysql']['initial_password']
    bind_address node['get-native']['mysql']['bind-address'] || '*'
    charset 'utf8'
    run_group 'mysql'
    run_user 'mysql'
    port 3306
    action [:create, :start]
end
