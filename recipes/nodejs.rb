#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: nodejs
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

include_recipe 'nodejs::nodejs_from_binary'
include_recipe 'nodejs::npm'

%w(gulp typings).each do |pkg|
    nodejs_npm pkg
end
