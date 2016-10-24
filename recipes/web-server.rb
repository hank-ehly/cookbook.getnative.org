#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: web-server
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

apt_update do
    action :update
end

execute 'upgrade' do
    command 'sudo apt-get -y upgrade'
    action :nothing
end

group node['get-native']['user']['primary_group'] do
    notifies :run, 'execute[upgrade]', :before
end

user node['get-native']['user']['name'] do
    group node['get-native']['user']['primary_group']
    home node['get-native']['user']['home']
    manage_home true
    password node['get-native']['user']['initial_password']
end

include_recipe 'sudo::default'

sudo node['get-native']['user']['primary_group'] do
    group node['get-native']['user']['primary_group']
    nopasswd true
    commands node['get-native']['user']['sudo_commands']
end

execute 'ssh-keygen' do
    user node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    creates "#{node['get-native']['user']['home']}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f #{node['get-native']['user']['home']}/.ssh/id_rsa -P \"\""
end

include_recipe 'build-essential::default'
include_recipe 'locale::default'

%w(git psmisc tree).each do |pkg|
    apt_package pkg
end

%w(default mod_ssl mod_deflate mod_rewrite mod_http2).each do |recipe|
    include_recipe "apache2::#{recipe}"
end

apt_package 'libnghttp2-dev'

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

server_name = node['get-native']['environment'] == 'production' ? 'get-native.com' : 'localhost:80'

web_app 'get-native.com' do
    template "get-native.com-#{node['get-native']['environment']}.conf.erb"
    server_port '80' # TODO: TLS
    server_name server_name
    docroot "/var/www/get-native.com/#{node['get-native']['environment']}/current/dist/prod"
end

mysql_client 'get-native' do
    version node['get-native']['mysql-version']
    action :create
end

include_recipe 'nodejs::nodejs_from_binary'
include_recipe 'nodejs::npm'
