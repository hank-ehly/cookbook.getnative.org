#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: network-usage
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

directory node['get-native']['local-log-dir']

root_bin = '/root/local/bin'

directory root_bin do
    recursive true
end

template 'network-usage' do
    path "#{root_bin}/network-usage.bash"
    source 'network-usage.bash.erb'
    owner 'root'
    group 'root'
    mode 0700
end

cron 'network-usage' do
    minute '0'
    hour '0'
    day '1'
    user 'root'
    mailto node['get-native']['contact']
    command "/bin/bash #{root_bin}/network-usage.bash"
end
