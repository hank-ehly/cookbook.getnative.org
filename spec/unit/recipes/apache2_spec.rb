#
# Cookbook Name:: get-native.com-cookbook
# Spec:: default
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

require 'spec_helper'

describe 'get-native.com-cookbook::apache2' do
    before(:each) do
        stub_command("/usr/sbin/apache2 -t").and_return(false)
    end

    context 'On the ubuntu 16.04 platform' do
        let(:chef_run) do
            runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
            runner.converge(described_recipe)
        end

        it 'converges successfully' do
            expect { chef_run }.to_not raise_error
        end

        it 'includes the `apache2` recipe' do
            expect(chef_run).to include_recipe('apache2::default')
        end

        it 'includes the `mod_ssl` recipe' do
            expect(chef_run).to include_recipe('apache2::mod_ssl')
        end

        it 'includes the `mod_deflate` recipe' do
            expect(chef_run).to include_recipe('apache2::mod_deflate')
        end

        it 'includes the `mod_rewrite` recipe' do
            expect(chef_run).to include_recipe('apache2::mod_rewrite')
        end

        it 'includes the `mod_http2` recipe' do
            expect(chef_run).to include_recipe('apache2::mod_http2')
        end

        it 'installs a apt_package with the default action' do
            expect(chef_run).to install_apt_package('libnghttp2-dev')
        end
    end
end
