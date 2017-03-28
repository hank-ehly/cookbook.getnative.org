#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: bootstrap
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'locale::default'
include_recipe 'openssh::default'

%w(ntp git psmisc tree tmux cron-apt).each do |pkg|
    apt_package pkg
end

execute 'timedatectl set-timezone UTC' do
    not_if "timedatectl status --no-pager | grep 'Time zone: UTC (UTC, +0000)'"
end

template '/etc/cron-apt/config' do
    source 'cron-apt.erb'
    owner 'root'
    group 'root'
    mode 0644
end
