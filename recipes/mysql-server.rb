#
# Cookbook Name:: cookbook.getnative.org
# Recipe:: mysql-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

data_bag = "#{node['getnative']['environment']}-#{node['getnative']['role']}"
db_credentials = data_bag_item(data_bag, 'db-credentials')

mysql_service 'getnative' do
    version node['getnative']['mysql']['version']
    initial_root_password db_credentials['root_password']
    bind_address node['getnative']['mysql']['bind-address'] || '*' # todo: defaulting to * is insecure
    charset 'utf8mb4'
    run_group 'mysql'
    run_user 'mysql'
    port 3306
    action [:create, :start]
end

mysql_config 'getnative-default-time-zone' do
    source 'mysql/default-time-zone.erb'
    notifies :restart, 'mysql_service[getnative]'
    instance 'getnative'
    action :create
end

mysql_config 'getnative_max_allowed_packet' do
    source 'mysql/max_allowed_packet.erb'
    notifies :restart, 'mysql_service[getnative]'
    instance 'getnative'
    action :create
    not_if { node['getnative']['environment'] == 'production' }
end

ruby_block 'Add db-credentials to deploy user\'s ENV' do
    block do
        f = Chef::Util::FileEdit.new("#{node['getnative']['user']['home']}/.bashrc")
        f.insert_line_if_no_match(/GETNATIVE_DB_PASS/, "export GETNATIVE_DB_PASS=\"#{db_credentials['getnative_password']}\"")
        f.write_file
    end
end
