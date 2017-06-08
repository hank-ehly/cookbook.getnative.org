#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: certbot
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

apt_package 'software-properties-common'

apt_repository 'certbot-certbot' do
    uri 'ppa:certbot/certbot'
    deb_src true
    notifies :run, 'execute[apt-get update]', :immediately
end

apt_package 'python-certbot-apache'
