# == Class profile_rundeck::install
#
# This class is called from profile_rundeck for install.
#
class profile_rundeck::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::ec2_metadata != undef {
    $public_hostname = $::facts['ec2_metadata']['public-ipv4']
  }
  else
  {
    if $::ec2_public_ipv4 != undef {
      $public_hostname = $::ec2_public_ipv4
    }
    else {
      $public_hostname = $::fqdn
    }
  }

  include java
  include apt

  $myframework_config = {
    'framework.server.name'     => $public_hostname,
    'framework.server.hostname' => $public_hostname,
    'framework.server.port'     => '4440',
    'framework.server.url'      => "http://${public_hostname}:4440",
    'framework.server.username' => 'admin',
    'framework.server.password' => 'admin',
    'rdeck.base'                => '/var/lib/rundeck',
    'framework.projects.dir'    => '/var/lib/rundeck/projects',
    'framework.etc.dir'         => '/etc/rundeck',
    'framework.var.dir'         => '/var/lib/rundeck/var',
    'framework.tmp.dir'         => '/var/lib/rundeck/var/tmp',
    'framework.logs.dir'        => '/var/lib/rundeck/logs',
    'framework.libext.dir'      => '/var/lib/rundeck/libext',
    'framework.ssh.keypath'     => '/var/lib/rundeck/.ssh/id_rsa',
    'framework.ssh.user'        => 'rundeck',
    'framework.ssh.timeout'     => '0',
    'rundeck.server.uuid'       => $::serialnumber,
  }

  class {'rundeck':
    grails_server_url => "http://${public_hostname}:4440",
    framework_config  => $myframework_config,
    require           => Class['java'],
  }

  package {'rundeck-cli':
    ensure  => present,
    require => Class['rundeck'],
  }

  file {'/var/lib/rundeck/libext/rundeck-json-plugin-1.1.jar':
    source  => 'puppet:///modules/profile_rundeck/rundeck-json-plugin-1.1.jar',
    require => Class['rundeck'],
  }

}
