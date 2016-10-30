#
# Cookbook Name:: get-native.com-cookbook
# Recipe:: nodejs
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

include_recipe 'nodejs::nodejs_from_binary'
include_recipe 'nodejs::npm'

%w(gulp-cli typings node-gyp).each do |pkg|
    nodejs_npm pkg
end

ruby_block 'Add npm module bin to PATH' do
    block do
        f = Chef::Util::FileEdit.new("#{node['get-native']['user']['home']}/.bashrc")
        f.insert_line_if_no_match(/nodejs-binary/, 'export PATH="/usr/local/nodejs-binary/bin:$PATH"')
        f.write_file
    end
end
