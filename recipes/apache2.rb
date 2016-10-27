#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: apache2
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

%w(default mod_ssl mod_deflate mod_rewrite mod_http2).each do |recipe|
    include_recipe "apache2::#{recipe}"
end

apt_package 'libnghttp2-dev'

extract_path = "#{Chef::Config[:file_cache_path]}/apache2"

bash 'mod_http2.so' do
    code <<-EOH
        sudo mkdir -p #{extract_path} && cd #{extract_path}
        sudo apt-get source apache2
        sudo apt-get build-dep -y apache2
        cd #{extract_path}/apache2-2.4.18
        sudo fakeroot debian/rules binary
        sudo cp debian/apache2-bin/usr/lib/apache2/modules/mod_http2.so #{node['apache']['libexec_dir']}/
        sudo chown root:root /usr/lib/apache2/modules/mod_http2.so
    EOH
    not_if { ::File.exists?("#{node['apache']['libexec_dir']}/mod_http2.so") }
end

directory '/var/www' do
    user 'root'
    group 'root'
    mode 0755
end

directory '/var/www/get-native.com' do
    user 'get-native'
    group node['apache2']['group']
    mode 0755
end

web_app 'get-native.com' do
    template 'get-native.com.conf.erb'
    server_name node['get-native']['server_name']
    docroot node['get-native']['docroot']
end
