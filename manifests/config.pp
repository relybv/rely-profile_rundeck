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
    mode    => '0750',
    source  => 'puppet:///modules/profile_rundeck/projects',
  }

  exec {'move projectsdir':
    command => '/bin/rm -rf /var/lib/rundeck/projects;/bin/mv /tmp/projects /var/lib/rundeck/',
    require => Class['rundeck'],
  }

  file {'/tmp/jobs/':
    ensure  => directory,
    recurse => true,
    owner   => 'rundeck',
    group   => 'rundeck',
    source  => 'puppet:///modules/profile_rundeck/jobs',
    require => Exec['wait for rundeck'],
  }

  exec {'wait for rundeck':
    require => Class['rundeck'],
    command => '/usr/bin/wget --spider --tries 10 --retry-connrefused http://localhost:4440 && /bin/sleep 60',
  }


  if $rundeck::jobs == true {
  #### rundeck jobs ####
  exec { 'inport check_sla job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/check_sla',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  exec { 'inport check_health job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/check_health',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  exec { 'inport check_lb_backends job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/check_lb_backends',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  exec { 'inport check_puppet_resources job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/check_puppet_resources',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  exec { 'inport disable_appl_lb job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/disable_appl_lb',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  exec { 'inport enable_appl_lb job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/enable_appl_lb',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  exec { 'inport update_package job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/update_package',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  exec { 'inport rolling_update_apache job':
    command     => '/usr/bin/rd jobs load --duplicate update --format yaml --project Management --file /tmp/jobs/rolling_update_apache',
    environment => ['RD_USER=admin', 'RD_PASSWORD=admin', 'RD_URL=http://localhost:4440'],
    require     => [ File['/tmp/jobs/'], Exec['wait for rundeck'] ],
  }

  }

}
