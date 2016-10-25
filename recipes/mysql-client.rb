#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: mysql-client
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

mysql_client 'get-native' do
    version node['get-native']['mysql-version']
    action :create
end
