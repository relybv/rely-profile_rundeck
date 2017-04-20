# == Class profile_rundeck::service
#
# This class is meant to be called from profile_rundeck.
# It ensure the service is running.
#
class profile_rundeck::service {
  # prevent direct use of subclass
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }


}
