#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: deploy-key
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

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

# curl https://api.github.com/repos/hank-ehly/get-native.com/keys/19767268 -H "Accept: application/vnd.github.v3+json" -i -u "hank-ehly:..." -X DELETE
