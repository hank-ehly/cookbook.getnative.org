#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: deploy
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

%W(#{node['getnative']['server_name']} api.#{node['getnative']['server_name']}).each do |domain|
    directory "#{node['apache']['docroot_dir']}/#{domain}" do
        user node['getnative']['user']['name']
        group node['apache']['group']
        mode 0755
    end

    conf_name = File::exist?("#{node['apache']['dir']}/ssl/live/#{domain}/fullchain.pem") ? "#{domain}-ssl" : domain

    web_app conf_name do
        template "web-app/#{node['getnative']['environment']}/#{conf_name}.conf.erb"
        server_name domain
    end
end
