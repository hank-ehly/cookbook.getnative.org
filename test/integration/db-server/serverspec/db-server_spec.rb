require 'spec_helper'

describe 'get-native.com-cookbook::db-server' do

    describe service('mysql-get-native') do
        it { should be_enabled }
        it { should be_running }
    end

end
