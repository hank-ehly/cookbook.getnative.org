#
# Cookbook Name:: get-native.com-cookbook
# Spec:: default
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

require 'spec_helper'

describe 'get-native.com-cookbook::bootstrap' do
    context 'On the ubuntu 16.04 platform' do
        let(:chef_run) do
            runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
            runner.converge(described_recipe)
        end

        it 'converges successfully' do
            expect { chef_run }.to_not raise_error
        end

        it 'includes the `apt` recipe' do
            expect(chef_run).to include_recipe('apt::default')
        end

        it 'includes the `build-essential` recipe' do
            expect(chef_run).to include_recipe('build-essential::default')
        end

        it 'includes the `locale` recipe' do
            expect(chef_run).to include_recipe('locale::default')
        end
    end
end
