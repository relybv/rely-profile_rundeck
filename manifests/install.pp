# == Class profile_rundeck::install
#
# This class is called from profile_rundeck for install.
#
class profile_rundeck::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $::ec2_public_ipv4 != undef {
    $public_hostname = $::ec2_public_ipv4
  }
  else
  {
    if $::ec2_metadata != undef {
      $public_hostname = $::facts['ec2_metadata']['public-ipv4']
    }
    else {
      $public_hostname = $::fqdn
    }
  }
  class { 'java':
    distribution => 'jdk',
  }
  class {'rundeck':
    package_ensure     => '2.6.11',
    server_web_context => "http://${public_hostname}:4440",
    require            => Class['java'],
  }

}
