# == Class profile_rundeck::config
#
# This class is called from profile_rundeck for service config.
#
class profile_rundeck::config {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
