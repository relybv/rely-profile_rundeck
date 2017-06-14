# == Class profile_rundeck::config
#
# This class is called from profile_rundeck for service config.
#
class profile_rundeck::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file {'/var/lib/rundeck/rundeckmcoinv.mco':
    source  => 'puppet:///modules/profile_rundeck/rundeckmcoinv.mco',
    require => Class['rundeck'],
  }

  file {'/tmp/projects/':
    ensure  => directory,
    recurse => true,
    owner   => 'rundeck',
    group   => 'rundeck',
    source  => 'puppet:///modules/profile_rundeck/projects',
    require => Class['rundeck'],
  }

  exec {'move projectsdir':
    command     => '/bin/rm -rf /var/lib/rundeck/projects;/bin/mv /tmp/projects /var/lib/rundeck/',
    subscribe   => File['/tmp/projects/'],
    refreshonly => true,
  }

  file {'/tmp/jobs/':
    ensure  => directory,
    recurse => true,
    owner   => 'rundeck',
    group   => 'rundeck',
    source  => 'puppet:///modules/profile_rundeck/jobs',
    require => Class['rundeck'],
  }

  exec { 'inport check_puppet_resources job':
    command     => 'RD_USER=admin RD_PASSWORD=admin RD_URL=http://localhost:4440 /usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/check_puppet_resources',
    path        => '/usr/bin',
    subscribe   => File['/tmp/jobs/'],
    refreshonly => true,
  }

}
