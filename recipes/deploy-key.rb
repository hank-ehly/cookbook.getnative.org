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

# 1. GET /repos/:owner/:repo/keys
# 2. Check if title=... key exists
# 3. If exists, exit 0
# 4. Else, POST /repos/:owner/:repo/keys
    # curl https://api.github.com/...
    # -H "Accept: application/vnd.github.v3+json"
    # -u "{github name}:{cat secret-password.txt}"
    # parse response with 'jr'
    # curl ... | jr '.[0] | .title" << gets you the title of the first object in the array response

ruby_block 'deploy-key' do

end
