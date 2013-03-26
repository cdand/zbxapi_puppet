Puppet::Type.newtype(:zbx_usergroup) do

  desc 'zbx_usergroup is used to manage the Usergroups configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix Usergroup'
  end

  newproperty(:usrgrpid) do
    desc 'The read-only usergrpid of the Zabbix Usergroup'
  end
	
	newproperty(:gui_access) do
		desc <<-EOT
		  Which authentication method do members of this Usergroup use to
			gain access to the Zabbix Web GUI.

			system   = System default authentication method (e.g. internal, http, ldap)
			internal = Internal authentication only
			disabled = No Web GUI access
	  EOT
#		defaultto :system
#		newvalues( :system, :internal, :disabled )
	end

	newproperty(:users_status) do
		desc 'Is this Usergroup enabled'
#		defaultto :true
#		newvalues( :true, :false )
	end

	newproperty(:debug_mode) do
		desc 'Is Debug mode enabled for members of this Usergroup'
#		defaultto :false
#		newvalues( :true, :false )
	end

end
