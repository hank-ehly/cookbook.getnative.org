require 'spec_helper'

describe 'get-native.com-cookbook::authorized-keys' do
    get_native_user = 'get-native'
    get_native_group = 'get-native'

    # Todo: Use have_authorized_key

    # describe user('root') do
    #     it { should have_authorized_key 'ssh-rsa ABCDEFGHIJKLMNOPQRSTUV... foo@bar.local' }
    # end

    describe file("/home/#{get_native_user}/.ssh") do
        it { should be_directory }
        it { should be_mode 700 }
        it { should be_owned_by get_native_user }
        it { should be_grouped_into get_native_group }
    end

    describe file("/home/#{get_native_user}/.ssh/authorized_keys") do
        it { should be_file }
        it { should be_mode 644 }
        it { should be_owned_by get_native_user }
        it { should be_grouped_into get_native_group }
        its(:size) { should > 0 }
    end
end
