require 'spec_helper'

describe 'get-native.com-cookbook::add-user' do
    get_native_user = 'get-native'
    get_native_group = 'get-native'

    describe group(get_native_group) do
        it { should exist }
    end

    describe user(get_native_user) do
        it { should exist }
        it { should belong_to_group get_native_group }
        it { should have_home_directory "/home/#{get_native_user}" }
        it { should have_login_shell '/bin/bash' }
    end

    describe file("/etc/sudoers.d/#{get_native_user}") do
        it { should exist }
        its(:content) { should match /get-native ALL=\(ALL:ALL\) NOPASSWD:ALL/ }
    end
end
