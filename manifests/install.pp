# == Class profile_rundeck::install
#
# This class is called from profile_rundeck for install.
#
class profile_rundeck::install {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  class { 'java':
    distribution => 'jre',
  }
  class {'rundeck':
  }
  Class['java'] -> Class['rundeck']

}
