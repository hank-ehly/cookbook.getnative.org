#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: mysql-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

data_bag = "#{node['get-native']['environment']}-#{node['get-native']['role']}"
db_credentials = data_bag_item(data_bag, 'db-credentials')

mysql_service 'get-native' do
    version node['get-native']['mysql']['version']
    initial_root_password db_credentials['root_password']
    bind_address node['get-native']['mysql']['bind-address'] || '*' # todo: defaulting to * is insecure
    charset 'utf8'
    run_group 'mysql'
    run_user 'mysql'
    port 3306
    action [:create, :start]
end

mysql_config 'get-native-default-time-zone' do
    source 'default-time-zone.erb'
    notifies :restart, 'mysql_service[get-native]'
    instance 'get-native'
    action :create
end

mysql_config 'get-native_max_allowed_packet' do
    source 'max_allowed_packet.erb'
    notifies :restart, 'mysql_service[get-native]'
    instance 'get-native'
    action :create
    not_if { node['get-native']['environment'] == 'production' }
end

ruby_block 'Add db-credentials to deploy user\'s ENV' do
    block do
        f = Chef::Util::FileEdit.new("#{node['get-native']['user']['home']}/.bashrc")
        f.insert_line_if_no_match(/GET_NATIVE_DB_PASS/, "export GET_NATIVE_DB_PASS=\"#{db_credentials['get_native_password']}\"")
        f.write_file
    end
end

execute 'Load MySQL Time Zone Data' do
    command "/usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root --password='#{db_credentials['get_native_password']}' mysql"
    sensitive true
    notifies :restart, 'mysql_service[get-native]'
    not_if { !Dir::exist?('/usr/share/zoneinfo') }
end
