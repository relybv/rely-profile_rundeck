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
    source  => 'puppet:///modules/profile_rundeck/rundeckmcoinv.mco',
    require => Class['rundeck'],
  }

  file { '/tmp/projects/':
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/profile_rundeck/projects',
    require => Class['rundeck'],
  }

  exec { 'move projectsdir':
    command     => '/bin/mv -u /tmp/projects /var/lib/rundeck/',
    subscribe   => File['/tmp/projects/'],
    refreshonly => true,
  }

}
