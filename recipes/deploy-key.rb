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

# TODO: Consider script instead
# curl https://api.github.com/repos/foo/.../keys/... -H "Accept: application/vnd.github.v3+json" -i -u "hank-ehly:..." -X DELETE
# http_request 'please_delete_me' do
#     headers node['github']['headers']
#     url 'https://api.github.com'
#     message ({:some => 'data'}.to_json)
#     action :post
# end
