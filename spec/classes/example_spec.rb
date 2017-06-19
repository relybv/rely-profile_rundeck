require 'spec_helper'

describe 'profile_rundeck' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({
            :concat_basedir => "/foo"
          })
        end

        context "profile_rundeck class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('profile_rundeck') }
          it { is_expected.to contain_class('profile_rundeck::install') }
          it { is_expected.to contain_class('profile_rundeck::config') }
          it { is_expected.to contain_class('profile_rundeck::service') }
          it { is_expected.to contain_class('java') }
          it { is_expected.to contain_class('rundeck') }

          it { is_expected.to contain_package('rundeck-cli') }

          it { is_expected.to contain_exec('inport check_health job') }
          it { is_expected.to contain_exec('inport check_lb_backends job') }
          it { is_expected.to contain_exec('inport check_puppet_resources job') }
          it { is_expected.to contain_exec('inport check_sla job') }
          it { is_expected.to contain_exec('inport disable_appl_lb job') }
          it { is_expected.to contain_exec('inport enable_appl_lb job') }
          it { is_expected.to contain_exec('inport rolling_update_apache job') }
          it { is_expected.to contain_exec('inport update_package job') }
          it { is_expected.to contain_exec('move projectsdir') }
          it { is_expected.to contain_exec('wait for rundeck') }

          it { is_expected.to contain_file('/tmp/jobs/') }
          it { is_expected.to contain_file('/tmp/projects/') }
          it { is_expected.to contain_file('/var/lib/rundeck/libext/rundeck-json-plugin-1.1.jar') }
          it { is_expected.to contain_file('/var/lib/rundeck/rundeckmcoinv.mco') }

        end
      end
    end
  end
end
