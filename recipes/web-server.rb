#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: web-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

execute 'update' do
    command 'sudo apt-get update -y'
    action :nothing
end

execute 'upgrade' do
    command 'sudo apt-get -y upgrade'
    action :nothing
end

include_recipe 'build-essential::default'
package 'git'
package 'psmisc'
include_recipe 'locale::default'

group node['get-native']['user']['primary_group'] do
    notifies :run, 'execute[update]', :before
    notifies :run, 'execute[upgrade]', :before
end

user node['get-native']['user']['name'] do
    group node['get-native']['user']['primary_group']
    home node['get-native']['user']['home']
    manage_home true
    password node['get-native']['user']['initial_password']
end

include_recipe 'sudo::default'

sudo node['get-native']['user']['name'] do
    template 'sudo-get_native.erb'
end

include_recipe 'apache2::default'
include_recipe 'apache2::mod_ssl'
include_recipe 'apache2::mod_deflate'
include_recipe 'apache2::mod_rewrite'

include_recipe 'apache2::mod_http2'
package 'libnghttp2-dev'

extract_path = "#{Chef::Config[:file_cache_path]}/apache2"

bash 'mod_http2.so' do
    code <<-EOH
        sudo mkdir -p #{extract_path} && cd #{extract_path}
        sudo apt-get source apache2
        sudo apt-get build-dep -y apache2
        cd #{extract_path}/apache2-2.4.18
        sudo fakeroot debian/rules binary
        sudo cp debian/apache2-bin/usr/lib/apache2/modules/mod_http2.so /usr/lib/apache2/modules/
        sudo chown root:root /usr/lib/apache2/modules/mod_http2.so
    EOH
    not_if { ::File.exists?('/usr/lib/apache2/modules/mod_http2.so') }
end

app_dist_dirname = node['get-native']['environment'] == 'development' ? 'dev' : 'prod'

web_app 'get-native.com' do
    template "get-native.com-#{node['get-native']['environment']}.conf.erb"
    server_port '80' # TODO
    server_name 'get-native.com'
    docroot "/var/www/get-native.com/#{node['get-native']['environment']}/current/dist/#{app_dist_dirname}"
end

mysql_client 'get-native' do
    version node['get-native']['mysql-version']
    action :create
end

include_recipe 'nodejs::nodejs_from_binary'
include_recipe 'nodejs::npm'
