#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: apache2
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

%w(software-properties-common python-software-properties libnghttp2-dev).each do |pkg|
    apt_package pkg
end

execute 'add-apt-repository -y ppa:ondrej/apache2' do
    notifies :run, 'execute[apt-get update]', :immediately
    not_if { File::exist? '/etc/apt/sources.list.d/ondrej-ubuntu-apache2-xenial.list' }
end

%w(default mod_ssl mod_deflate mod_rewrite mod_proxy mod_proxy_http mod_http2 mod_expires mod_setenvif).each do |recipe|
    include_recipe "apache2::#{recipe}"
end

apache_module 'proxy_http2'
