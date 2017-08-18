#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: deploy
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

%W(#{node['getnative']['server_name']} api.#{node['getnative']['server_name']} admin.#{node['getnative']['server_name']}).each do |domain|
    directory "#{node['apache']['docroot_dir']}/#{domain}" do
        user node['getnative']['user']['name']
        group node['apache']['group']
        mode 0755
    end

    template_name = 'default'
    config_name = domain

    if File::exist?("#{node['apache']['dir']}/ssl/live/#{domain}/fullchain.pem")
        config_name = template_name = "#{domain}-ssl"

        template "#{node['apache']['docroot_dir']}/#{domain}/index.html" do
            source 'web-app/index.html.erb'
            mode 0644
            owner node['getnative']['user']['name']
            group node['apache']['group']
            variables({domain: domain})
        end
    end

    web_app config_name do
        template "web-app/#{node['getnative']['environment']}/#{template_name}.conf.erb"
        server_name domain
    end
end
