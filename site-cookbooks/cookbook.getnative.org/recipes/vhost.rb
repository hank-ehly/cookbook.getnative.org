#
# Cookbook Name:: cookbook.getnative.org
# Recipe:: deploy
#
# Copyright (c) 2017 Hank Ehly, All Rights Reserved.

def platform_to_domain(platform)
    case platform
        when 'client' then
            node['getnative']['server_name']
        when 'api', 'admin' then
            "#{platform}.#{node['getnative']['server_name']}"
        else
            raise "Invalid platform: #{platform}"
    end
end

def platform_to_project_root(platform)
    case platform
        when 'client' then
            "#{node['apache']['docroot_dir']}/#{node['getnative']['domain']}"
        when 'api', 'admin' then
            "#{node['apache']['docroot_dir']}/#{platform}.#{node['getnative']['domain']}"
        else
            raise "Invalid platform: #{platform}"
    end
end

%w(client api admin).each do |platform|
    project_root = platform_to_project_root(platform)
    stage_root = "#{project_root}/#{node['getnative']['environment']}"

    [project_root, stage_root].each do |dir|
        directory dir do
            user node['getnative']['user']['name']
            group node['apache']['group']
            mode 0755
        end
    end

    domain = platform_to_domain(platform)
    tls_cert_exists = File::exist?("#{node['apache']['dir']}/ssl/live/#{domain}/fullchain.pem")
    template_name = tls_cert_exists ? "#{domain}-ssl" : 'default'
    web_app_name = tls_cert_exists ? "#{domain}-ssl" : domain

    web_app web_app_name do
        template "vhost/#{node['getnative']['environment']}/#{template_name}.conf.erb"
        server_name domain
        docroot stage_root
    end
end
