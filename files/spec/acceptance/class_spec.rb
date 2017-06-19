if ENV['BEAKER'] == 'true'
  # running in BEAKER test environment
  require 'spec_helper_acceptance'
else
  # running in non BEAKER environment
  require 'serverspec'
  set :backend, :exec
end

describe 'profile_rundeck class' do

  context 'default parameters' do
    if ENV['BEAKER'] == 'true'
      # Using puppet_apply as a helper
      it 'should work with no errors' do
        pp = <<-EOS
        class { 'profile_rundeck': jobs => false, }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end
    end

    describe package('rundeck') do
      it { is_expected.to be_installed }
    end

    describe package('rundeck-cli') do
      it { is_expected.to be_installed }
    end

    describe service('rundeckd') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe port(4440) do
      it { should be_listening }
    end

  end
end
