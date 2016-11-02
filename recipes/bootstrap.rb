#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: bootstrap
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

include_recipe 'apt::default'
include_recipe 'build-essential::default'
include_recipe 'locale::default'
