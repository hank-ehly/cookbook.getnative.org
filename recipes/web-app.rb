#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: web-app
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

stage = node['getnative']['environment']
tasks_path = "/var/www/api.#{node['getnative']['server_name']}/#{stage}/app/tasks"

%w(libtool autoconf libav-tools).each do |pkg|
    apt_package pkg
end

directory node['apache']['docroot_dir'] do
    user 'root'
    group 'root'
    mode 0755
end

if stage != 'production'
    data_bag = "#{node['getnative']['environment']}-#{node['getnative']['role']}"
    htpasswd = data_bag_item(data_bag, 'htpasswd')

    bash 'htpasswd' do
        code <<-EOH
            echo "#{htpasswd['password']}" | htpasswd -iBc #{node['apache']['dir']}/.htpasswd #{htpasswd['user']}
        EOH

        not_if { File::exist? "#{node['apache']['dir']}/.htpasswd" }
    end
end

cron 'Backup Database' do
    command "if [ -f #{tasks_path}/backup-db.js ]; then NODE_ENV=#{stage} /usr/local/nodejs-binary/bin/node -e 'require(\"#{tasks_path}/backup-db.js\")()'; fi"
    minute '0'
    hour '0'
    user 'root'
    mailto node['getnative']['contact']
end

cron 'Destroy Stale StudySession Records' do
    command "if [ -f #{tasks_path}/study-sessions/clean.js ]; then NODE_ENV=#{stage} /usr/local/nodejs-binary/bin/node -e 'require(\"#{tasks_path}/study-sessions/clean.js\")()'; fi"
    minute '10'
    hour '0'
    user 'root'
    mailto node['getnative']['contact']
end

cron 'Destroy Stale VerificationToken Records' do
    command "if [ -f #{tasks_path}/verification-tokens/clean.js ]; then NODE_ENV=#{stage} /usr/local/nodejs-binary/bin/node -e 'require(\"#{tasks_path}/verification-tokens/clean.js\")()'; fi"
    minute '15'
    hour '0'
    user 'root'
    mailto node['getnative']['contact']
end
