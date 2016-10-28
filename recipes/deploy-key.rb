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

deploy_key node['get-native']['environment'] do
    provider Chef::Provider::DeployKeyGithub
    path "#{node['get-native']['user']['home']}/.ssh"
    credentials({
                        user: data_bag_item('github', 'credentials')['username'],
                        password: data_bag_item('github', 'credentials')['password']
                })
    repo node['get-native']['github']['repo']
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    action :add
end

template 'github-ssh-config' do
    source 'ssh-config.erb'
    path "#{node['get-native']['user']['home']}/.ssh/config"
    mode 0700
    owner node['get-native']['user']['name']
    group node['get-native']['user']['primary_group']
    variables({
                      host: 'github.com',
                      user: 'git',
                      hostname: 'github.com',
                      identity_file: "#{node['get-native']['user']['home']}/.ssh/#{node['get-native']['environment']}"
              })
end
