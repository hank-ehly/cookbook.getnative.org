#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: app
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

%w(gulp-cli typings node-gyp pm2).each do |pkg|
    nodejs_npm pkg
end

directory node['apache']['docroot_dir'] do
    user 'root'
    group 'root'
    mode 0755
end

directory '/var/www/get-native.com' do
    user node['get-native']['user']['name']
    group node['apache']['group']
    mode 0755
end

deploy 'get-native' do
    user node['get-native']['user']['name']
    group node['apache']['group']
    branch 'master'
    repo "git@github.com:#{node['get-native']['github']['repo']}"
    symlink_before_migrate nil
    create_dirs_before_symlink []
    purge_before_symlink []
    symlinks nil

    # Todo: Use pm2
    restart_command '/usr/local/nodejs-binary/bin/node /var/www/get-native/current/src/server/index.js'
end

web_cert_path = "#{node['apache']['dir']}/ssl/live/#{node['get-native']['server_name']}/fullchain.pem"
api_cert_path = "#{node['apache']['dir']}/ssl/live/api.#{node['get-native']['server_name']}/fullchain.pem"
certs_exist = File::exist?(web_cert_path) && File::exist?(api_cert_path)

%W(#{node['get-native']['server_name']} api.#{node['get-native']['server_name']}).each do |domain|
    web_app domain do
        template certs_exist ? "#{domain}-ssl.conf.erb" : "#{domain}.conf.erb"
        server_name domain
        docroot node['get-native']['docroot']
    end
end
