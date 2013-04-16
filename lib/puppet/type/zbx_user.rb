Puppet::Type.newtype(:zbx_user) do

  desc 'zbx_user is used to manage the Users configured in your Zabbix server'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The username of the Zabbix User'
  end

  newproperty(:userid) do
    desc 'The read-only userid of the Zabbix User'
  end

  newproperty(:firstname) do
    desc 'The firstname of the Zabbix User'
    defaultto 'Default'
  end

  newproperty(:surname) do
    desc 'The surname of the Zabbix User'
    defaultto 'User'
  end

  newproperty(:usertype) do
    desc 'The usertype of the Zabbix User'
    defaultto 'user'
    newvalues( 'user', 'admin', 'super' )
    munge do |value|
      case value
      when 'user'
        1
      when 'admin'
        2
      when 'super'
        3
      end
    end
  end

  newproperty(:usergroups, :array_matching => :all) do
    desc <<-EOT
      Array of Usergroups the Zabbix User is a member of.

			e.g. ['Zabbix Administrators', 'Support Staff']

      Note, currently the array must be in Usergroup ID numerical order. If you
      see Puppet reports frequently changing a User's group check the order in which
      Puppet says it is changing them from and to.
    EOT
  end

  autorequire(:zbx_usergroup) do
    self[:usergroups]
  end

##  Just leaving this out for now...it's not exactly critical.
#  newproperty(:theme) do
#    desc <<-EOT
#      Zabbix theme for user's GUI access
#
#      default      = Use the system wide default
#      classic      = Classic theme
#      originalblue = Original blue them
#      darkblue     = Dark blue them
#      darkorange   = Dark orange them
#    EOT
#    defaultto :default
#    newvalues( :default, :classic, :originalblue, :darkblue, :darkorange )
#	end

end
