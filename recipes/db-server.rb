#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: db-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

execute 'update' do
    command 'sudo apt-get update -y'
    action :nothing
end

execute 'upgrade' do
    command 'sudo apt-get -y upgrade'
    action :nothing
end

include_recipe 'build-essential::default'
package 'psmisc'

mysql_service 'get-native' do
    version node['get-native']['mysql-version']
    initial_root_password 'root'
    bind_address '0.0.0.0'
    charset 'utf8'
    run_group 'mysql'
    run_user 'mysql'
    port 3306
    notifies :run, 'execute[update]', :before
    notifies :run, 'execute[upgrade]', :before
    action [:create, :start]
end
