#
# Cookbook Name:: get-native.com-cookbook
# Spec:: default
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

require 'spec_helper'

describe 'get-native.com-cookbook::add-user' do
    before(:each) do
        stub_command('which sudo').and_return(false)
    end

    context 'On the ubuntu 16.04 platform' do
        let(:chef_run) do
            runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04') do |node|
                node.normal['get-native']['user']['primary_group'] = 'get-native'
            end.converge(described_recipe)
        end

        it 'converges successfully' do
            expect { chef_run }.to_not raise_error
        end

        it 'creates the get-native' do
            expect(chef_run).to create_group('get-native')
        end

        it 'includes the `sudo` recipe' do
            expect(chef_run).to include_recipe('sudo::default')
        end
    end
end
