#
# Cookbook Name:: cookbook.getnativelearning.com
# Recipe:: deploy
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

%w(getnativelearning.com api.getnativelearning.com admin.getnativelearning.com).each do |domain|
    parent = "#{node['apache']['docroot_dir']}/#{domain}"
    child = "#{node['apache']['docroot_dir']}/#{domain}/#{node['getnative']['environment']}"

    [parent, child].each do |dir|
        directory dir do
            user node['getnative']['user']['name']
            group node['apache']['group']
            mode 0755
        end
    end

    # Add template manually
    # template 'index.html' do
    #     path "#{node['apache']['docroot_dir']}/#{domain}/#{node['getnative']['environment']}/index.html"
    #     source 'vhost/index.html.erb'
    #     retries 1
    #     mode 0644
    #     owner node['getnative']['user']['name']
    #     group node['apache']['group']
    #     variables({domain: domain})
    #     action :nothing
    # end
end

%W(#{node['getnative']['server_name']} api.#{node['getnative']['server_name']} admin.#{node['getnative']['server_name']}).each do |domain|
    tls_cert_exists = File::exist?("#{node['apache']['dir']}/ssl/live/#{domain}/fullchain.pem")
    template_name = tls_cert_exists ? "#{domain}-ssl" : 'default'
    web_app_name = tls_cert_exists ? "#{domain}-ssl" : domain

    web_app web_app_name do
        template "vhost/#{node['getnative']['environment']}/#{template_name}.conf.erb"
        server_name domain
    end
end
