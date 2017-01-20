#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: get-native-api
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

web_app 'api.stg.get-native.com' do
    template 'api.stg.get-native.com.conf.erb'
    server_name 'api.stg.get-native.com.conf'
end
