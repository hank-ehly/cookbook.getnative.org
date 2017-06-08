#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: deploy
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

%W(#{node['get-native']['server_name']} api.#{node['get-native']['server_name']} docs.#{node['get-native']['server_name']}).each do |domain|
    directory "#{node['apache']['docroot_dir']}/#{domain}" do
        user node['get-native']['user']['name']
        group node['apache']['group']
        mode 0755
    end

    conf_name = File::exist?("#{node['apache']['dir']}/ssl/live/#{domain}/fullchain.pem") ? "#{domain}-ssl" : domain

    web_app conf_name do
        template "web-app/#{node['get-native']['environment']}/#{conf_name}.conf.erb"
        server_name domain
        docroot node['get-native']['docroot']
    end
end
