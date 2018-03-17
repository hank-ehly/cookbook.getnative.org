#
# Cookbook Name:: cookbook.getnative.org
# Recipe:: mysql-client
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

mysql_client 'getnative' do
    version node['getnative']['mysql']['version']
    action :create
end
