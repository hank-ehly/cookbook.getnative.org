#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: apache2
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

%w(default mod_ssl mod_deflate mod_rewrite).each do |recipe|
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

# Use apache2 from http://archive.apache.org/dist/httpd/httpd-2.4.18.tar.gz to get http2. Don't deal with this 'fakeroot' stuff
# Download mod_proxy_http2.so
