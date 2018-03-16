require 'spec_helper'

describe 'cookbook.getnative.org::deploy-key' do
    getnative_user = 'getnative'
    getnative_group = 'getnative'

    describe file("/home/#{getnative_user}/.ssh") do
        it { should be_directory }
        it { should be_mode 700 }
        it { should be_owned_by getnative_user }
        it { should be_grouped_into getnative_group }
    end

    describe file("/home/#{getnative_user}/.ssh/config") do
        it { should be_file }
        it { should be_mode 700 }
        it { should be_owned_by getnative_user }
        it { should be_grouped_into getnative_group }
        its(:content) { should match /Host github\.com/ }
    end
end
