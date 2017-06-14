# == Class profile_rundeck::config
#
# This class is called from profile_rundeck for service config.
#
class profile_rundeck::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { '/var/lib/rundeck/rundeckmcoinv.mco':
    source  => 'puppet:///modules/profile_rundeck/',
    require => Class['rundeck'],
  }

  rundeck::config::project { 'Management':
    file_copier_provider   => 'script-copy',
    node_executor_provider => 'script-exec',
    ssh_keypath            => '/var/lib/rundeck/.ssh/id_rsa',
  }

  rundeck::config::resource_source { 'resource':
    project_name        => 'Management',
    number              => '1',
    source_type         => 'script',
    include_server_node => false,
    resource_format     => 'resourceyaml',
    script_file         => '/usr/local/bin/mco',
    script_args         => 'inventory --script /var/lib/rundeck/rundeckmcoinv.mco',
    script_args_quoted  => true,
  }

}
