# == Class: profile_rundeck
#
# Full description of class profile_rundeck here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class profile_rundeck (
  $jobs = true
){
  class { '::profile_rundeck::install': }
  -> class { '::profile_rundeck::config': }
  ~> class { '::profile_rundeck::service': }
  -> Class['::profile_rundeck']
}
