#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: bootstrap
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

apt_update 'update-packages' do
    action :update
end

include_recipe 'build-essential::default'
include_recipe 'locale::default'

%w(git psmisc tree).each do |pkg|
    apt_package pkg
end
