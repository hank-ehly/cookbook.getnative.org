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

%w(default mod_ssl mod_deflate mod_rewrite mod_proxy mod_proxy_http mod_http2).each do |recipe|
    include_recipe "apache2::#{recipe}"
end

apache_module 'proxy_http2'

# extract_path = "#{Chef::Config[:file_cache_path]}/apache2"

# bash 'mod_http2.so' do
#     code <<-EOH
#         sudo mkdir -p #{extract_path} && cd #{extract_path}
#         sudo apt-get source apache2=2.4.25-0.0+deb.sury.org~xenial+1
#         sudo apt-get build-dep -y apache2
#         cd #{extract_path}/apache2-2.4.25
#         sudo fakeroot debian/rules binary
#         sudo cp debian/apache2-bin/usr/lib/apache2/modules/mod_http2.so #{node['apache']['libexec_dir']}/
#         sudo chown root:root /usr/lib/apache2/modules/mod_http2.so
#     EOH
#     not_if { ::File.exists?("#{node['apache']['libexec_dir']}/mod_http2.so") }
# end

# Use apache2 from http://archive.apache.org/dist/httpd/httpd-2.4.18.tar.gz to get http2. Don't deal with this 'fakeroot' stuff
# Download mod_proxy_http2.so

# apache2=2.4.25-0.0+deb.sury.org~xenial+1
