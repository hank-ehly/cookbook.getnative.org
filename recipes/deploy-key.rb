#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: deploy-key
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

ssh_dir = "#{node['getnative']['user']['home']}/.ssh"

directory ssh_dir do
    mode 0700
    owner node['getnative']['user']['name']
    group node['getnative']['user']['primary_group']
end

template '~/.ssh/config' do
    source 'deploy-key/ssh-config.erb'
    path "#{ssh_dir}/config"
    mode 0700
    owner node['getnative']['user']['name']
    group node['getnative']['user']['primary_group']
    variables({
        host: 'github.com',
        user: 'git',
        hostname: 'github.com',
        identity_file: "#{ssh_dir}/deploy"
    })
end

execute 'Create deploy key' do
    command "ssh-keygen -t rsa -q -C '' -f '#{ssh_dir}/deploy' -P \"\""
    not_if { File::exist? "#{ssh_dir}/deploy" and File::exist? "#{ssh_dir}/deploy.pub" }
end

%w(deploy deploy.pub).each do |f|
    file "#{ssh_dir}/#{f}" do
        owner node['getnative']['user']['name']
        group node['getnative']['user']['primary_group']
        mode 0600
    end
end
