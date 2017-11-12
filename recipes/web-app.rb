#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: web-app
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

%w(libtool autoconf libav-tools).each do |pkg|
    apt_package pkg
end

execute 'npm install -g pm2'

directory node['apache']['docroot_dir'] do
    user 'root'
    group 'root'
    mode 0755
end

%w(/var/log/pm2 /run/pm2).each do |d|
    directory d do
        user node['getnative']['user']['name']
        group node['getnative']['user']['primary_group']
        mode 0755
    end
end

if node['getnative']['environment'] != 'production'
    data_bag = "#{node['getnative']['environment']}-#{node['getnative']['role']}"
    htpasswd = data_bag_item(data_bag, 'htpasswd')

    bash 'htpasswd' do
        code <<-EOH
            echo "#{htpasswd['password']}" | htpasswd -iBc #{node['apache']['dir']}/.htpasswd #{htpasswd['user']}
        EOH

        not_if { File::exist? "#{node['apache']['dir']}/.htpasswd" }
    end
end


tasks_path = "/var/www/api.#{node['getnative']['server_name']}/current/app/tasks"
node_env = node['getnative']['node_env'] || 'development'

cron 'Daily backup-db' do
    command "if [ -f #{tasks_path}/backup-db.js ]; then NODE_ENV=#{node_env} /usr/local/nodejs-binary/bin/node -e 'require(\"#{tasks_path}/backup-db.js\")'; fi"
    minute '0'
    hour '0'
    user 'root'
    mailto node['getnative']['contact']
end

cron 'Daily update-views' do
    command "if [ -f #{tasks_path}/update-views.js ]; then NODE_ENV=#{node_env} /usr/local/nodejs-binary/bin/node -e 'require(\"#{tasks_path}/update-views.js\")'; fi"
    minute '0'
    hour '0'
    user 'root'
    mailto node['getnative']['contact']
end

cron 'Daily study-sessions/clean' do
    command "if [ -f #{tasks_path}/study-sessions/clean.js ]; then NODE_ENV=#{node_env} /usr/local/nodejs-binary/bin/node -e 'require(\"#{tasks_path}/study-sessions/clean.js\")'; fi"
    minute '0'
    hour '0'
    user 'root'
    mailto node['getnative']['contact']
end

cron 'Daily verification-tokens/clean' do
    command "if [ -f #{tasks_path}/verification-tokens/clean.js ]; then NODE_ENV=#{node_env} /usr/local/nodejs-binary/bin/node -e 'require(\"#{tasks_path}/verification-tokens/clean.js\")'; fi"
    minute '0'
    hour '0'
    user 'root'
    mailto node['getnative']['contact']
end
