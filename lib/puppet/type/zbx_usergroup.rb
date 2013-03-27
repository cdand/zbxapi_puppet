Puppet::Type.newtype(:zbx_usergroup) do

  desc 'zbx_usergroup is used to manage the Usergroups configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix Usergroup'
  end

  newproperty(:usrgrpid) do
    desc 'The read-only usergrpid of the Zabbix Usergroup'
  end
	
	newproperty(:authentication) do
		desc <<-EOT
		  Which authentication method do members of this Usergroup use to
			gain access to the Zabbix Web GUI.

			system   = System default authentication method (e.g. internal, http, ldap)
			internal = Internal authentication only
			disabled = No Web GUI access
	  EOT
		defaultto :system
		newvalues( :system, :internal, :disabled )
		munge do |value|
			case value
			when "system"
				0
			when "internal"
				1
			when "disabled"
				2
			end
		end
	end

	newproperty(:enabled) do
		desc <<-EOT
      Is this Usergroup enabled.

			true  = Member of this Usergroup can login
			false = Members of this usergroup cannot login
		EOT
		defaultto :true
		newvalues( :true, :false )
		munge do |value|
			case value
			when "true"
				0
			when "false"
				1
			end
		end
	end

	newproperty(:debug) do
		desc <<-EOT
      Is Debug mode enabled for members of this Usergroup'

			true
			false
		EOT
		defaultto :false
		newvalues( :true, :false )
		munge do |value|
			case value
			when "true"
				1
			when "false"
				0
			end
		end
	end

end
