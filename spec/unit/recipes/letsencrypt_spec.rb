#
# Cookbook Name:: get-native.com-cookbook
# Spec:: default
#
# Copyright (c) 2016 Hank Ehly, All Rights Reserved.

require 'spec_helper'

describe 'get-native.com-cookbook::letsencrypt' do
    context 'When all attributes are default, on an unspecified platform' do
        let(:chef_run) do
            runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
            runner.converge(described_recipe)
        end

        it 'converges successfully' do
            expect { chef_run }.to_not raise_error
        end
    end
end
