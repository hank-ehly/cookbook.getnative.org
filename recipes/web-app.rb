#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: web-app
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

%w(libtool autoconf mkdocs).each do |pkg|
    apt_package pkg
end

%w(gulp-cli pm2).each do |pkg|
    nodejs_npm pkg
end

directory node['apache']['docroot_dir'] do
    user 'root'
    group 'root'
    mode 0755
end

%w(/var/log/pm2 /run/pm2).each do |d|
    directory d do
        user 'root'
        group 'root'
        mode 0777
    end
end

data_bag = "#{node['get-native']['environment']}-#{node['get-native']['role']}"
htpasswd = data_bag_item(data_bag, 'htpasswd')

bash 'htpasswd' do
    code <<-EOH
        echo "#{htpasswd['password']}" | htpasswd -iBc #{node['apache']['dir']}/.htpasswd #{htpasswd['user']}
    EOH

    not_if { File::exist? "#{node['apache']['dir']}/.htpasswd" }
end
