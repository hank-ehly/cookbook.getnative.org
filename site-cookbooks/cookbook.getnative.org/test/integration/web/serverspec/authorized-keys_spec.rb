require 'spec_helper'

describe 'cookbook.getnative.org::authorized-keys' do
    getnative_user = 'getnative'
    getnative_group = 'getnative'

    # Todo: Use have_authorized_key

    # describe user('root') do
    #     it { should have_authorized_key 'ssh-rsa ABCDEFGHIJKLMNOPQRSTUV... foo@bar.local' }
    # end

    describe file("/home/#{getnative_user}/.ssh") do
        it { should be_directory }
        it { should be_mode 700 }
        it { should be_owned_by getnative_user }
        it { should be_grouped_into getnative_group }
    end

    describe file("/home/#{getnative_user}/.ssh/authorized_keys") do
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by getnative_user }
        it { should be_grouped_into getnative_group }
        its(:size) { should > 0 }
    end
end
