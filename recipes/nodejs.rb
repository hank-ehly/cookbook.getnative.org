#
# Cookbook Name:: cookbook.getnative.org
# Recipe:: nodejs
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

include_recipe 'nodejs::nodejs_from_binary'
include_recipe 'nodejs::npm'
