#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: nodejs
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'nodejs::nodejs_from_binary'
include_recipe 'nodejs::npm'
