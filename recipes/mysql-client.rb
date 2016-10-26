#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: mysql-client
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

mysql_client 'get-native' do
    version node['get-native']['mysql']['version']

    # TODO: Update after bugfix
    # https://github.com/chef-cookbooks/mysql/issues/471
    package_version '5.7.16-0ubuntu0.16.04.1'

    action :create
end
