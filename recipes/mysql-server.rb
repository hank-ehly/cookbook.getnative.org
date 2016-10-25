#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: mysql-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

mysql_service 'get-native' do
    version node['get-native']['mysql']['version']
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
              --password=#{node['get-native']['mysql']['initial_password']} \
              -S /var/run/mysql-get-native/mysqld.sock \
              -e 'CREATE DATABASE IF NOT EXISTS get_native DEFAULT CHARACTER SET UTF8;'
    EOH
end
