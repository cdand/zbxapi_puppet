# Class: zbxapi
# 
# This class installs the Zabbix API Gem, zbxapi developed by Red-Tux 
# https://github.com/red-tux/zbxapi
#
# Parameters: none
#
# Actions:
#
# Requires: nothing
#
# Sample Usage:
#
# class { 'zbxapi': }
#
class zbxapi {

  package { 'zbxapi':
    ensure   => present,
    provider => gem,
  }

}
