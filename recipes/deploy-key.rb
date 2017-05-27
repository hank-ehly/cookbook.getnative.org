#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: deploy-key
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

ssh_dir = "#{node['get-native']['user']['home']}/.ssh"

directory ssh_dir do
    mode 0700
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
end

template '~/.ssh/config' do
    source 'deploy-key/ssh-config.erb'
    path "#{ssh_dir}/config"
    mode 0700
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    variables({
        host: 'github.com',
        user: 'git',
        hostname: 'github.com',
        identity_file: "#{ssh_dir}/#{node['get-native']['environment']}"
    })
end

execute 'Create deploy key' do
    command "ssh-keygen -t rsa -q -C '' -f '#{ssh_dir}/#{node['get-native']['environment']}' -P \"\""
    not_if { File::exist? "#{ssh_dir}/#{node['get-native']['environment']}" and File::exist? "#{ssh_dir}/#{node['get-native']['environment']}.pub" }
end

file "#{ssh_dir}/#{node['get-native']['environment']}" do
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    mode 0600
end

file "#{ssh_dir}/#{node['get-native']['environment']}.pub" do
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    mode 0600
end
