#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: network-usage
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

directory node['get-native']['local-log-dir']

directory '/root/bin'

template 'network-usage' do
    path '/root/bin/network-usage.bash'
    source 'network-usage.bash.erb'
    owner 'root'
    group 'root'
    mode 0644
end

cron 'network-usage' do
    minute '0'
    hour '0'
    day '1'
    user 'root'
    mailto node['get-native']['contact']
    command '/bin/bash root/bin/network-usage.bash'
end
