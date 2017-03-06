#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: mysql-client
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

mysql_client 'get-native' do
    version node['get-native']['mysql']['version']
    action :create
end

data_bag = "#{node['get-native']['environment']}-#{node['get-native']['role']}"
db_credentials = data_bag_item(data_bag, 'db-credentials')

ruby_block 'Add db-credentials to deploy user\'s ENV' do
    block do
        f = Chef::Util::FileEdit.new("#{node['get-native']['user']['home']}/.bashrc")
        f.insert_line_if_no_match(/GET_NATIVE_DB_PASS/, "export GET_NATIVE_DB_PASS=\"#{db_credentials['get_native_password']}\"")
        f.write_file
    end
end
