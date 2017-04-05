#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: deploy
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

# todo: Match directory name to server_name (apache config and other places will also need modification)
directory "#{node['apache']['docroot_dir']}/get-native.com" do
    user node['get-native']['user']['name']
    group node['apache']['group']
    mode 0755
end

%W(#{node['get-native']['server_name']} api.#{node['get-native']['server_name']} docs.#{node['get-native']['server_name']}).each do |domain|
    conf_name = File::exist?("#{node['apache']['dir']}/ssl/live/#{domain}/fullchain.pem") ? "#{domain}-ssl" : domain

    web_app conf_name do
        template "web-app/#{conf_name}.conf.erb"
        server_name domain
        docroot node['get-native']['docroot']
    end
end
