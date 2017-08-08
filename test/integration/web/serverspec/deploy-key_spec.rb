require 'spec_helper'

describe 'cookbook.getnativelearning.com::deploy-key' do
    get_native_user = 'getnative'
    get_native_group = 'getnative'

    describe file("/home/#{get_native_user}/.ssh") do
        it { should be_directory }
        it { should be_mode 700 }
        it { should be_owned_by get_native_user }
        it { should be_grouped_into get_native_group }
    end

    describe file("/home/#{get_native_user}/.ssh/config") do
        it { should be_file }
        it { should be_mode 700 }
        it { should be_owned_by get_native_user }
        it { should be_grouped_into get_native_group }
        its(:content) { should match /Host github\.com/ }
    end
end
