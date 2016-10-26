#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: deploy-key
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

directory "#{node['get-native']['user']['home']}/.ssh" do
    mode '0700'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end

execute 'ssh-keygen' do
    user node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    creates "#{node['get-native']['user']['home']}/.ssh/id_rsa.pub"
    command "ssh-keygen -t rsa -q -f #{node['get-native']['user']['home']}/.ssh/id_rsa -P \"\""
end

cookbook_file 'deploy-key.bash' do
    path '/tmp/deploy-key.bash'
    source 'deploy-key.bash'
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    mode '0755'
end

execute 'upload deploy-key' do
    command '/usr/bin/env bash /tmp/deploy-key.bash'
end
