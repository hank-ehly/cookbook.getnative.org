#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: network-usage
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

directory node['get-native']['local-log-dir']

cron 'network-usage' do
    minute '0'
    hour '0'
    user 'root'
    mailto node['get-native']['contact']
    command %W{
        /bin/echo \"* `date`\" &&
        iptables -S -Z -v |
        /usr/bin/awk '/^-P/{ print $2, $6 }' |
        /usr/bin/tr ' ' '\t' >> #{node['get-native']['local-log-dir']}/network-usage.log 2>&1
    }.join(' ')
end
