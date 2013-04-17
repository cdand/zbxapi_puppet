Puppet::Type.newtype(:zbx_template_trigger) do

  desc <<-EOT
    zbx_template_trigger is used to manage Zabbix template triggers.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Name of the trigger'
  end

  newproperty(:triggerid) do
    desc '(read-only) ID of the trigger'
  end

  newproperty(:hostid) do
    desc <<-EOT
      (read-only) ID of the template
    EOT
  end

  newproperty(:template) do
    desc <<-EOT
      Name of the template that the item belongs to.
    EOT
  end

  autorequire(:zbx_template) do
    self[:template]
  end

  newproperty(:expression) do
		#TODO validate format of expression
    desc <<-EOT
      (read-only) ID of the trigger
    EOT
  end

  newproperty(:comments) do
    desc <<-EOT
      Additional comments to the trigger.
    EOT
  end

  newproperty(:priority) do
    desc <<-EOT
      Severity of the trigger. 
      
      'not classified' (default)  
      'information'
      'warning'
      'average'
      'high'
      'disaster'
    EOT
    defaultto 'not classified'
    newvalues( 'not classified', 'information', 'warning', 'average', 'high', 'disaster' )
    munge do |value|
      case value
      when 'not classified'
        0
      when 'information'
        1
      when 'warning'
        2
      when 'average'
        3
      when 'high'
        4
      when 'disaster'
        5
      end
    end
  end

  newproperty(:enabled) do
    desc <<-EOT
      Whether the trigger is enabled or disabled. 

      'true' (default)
      'false'
    EOT
    defaultto 'true'
    newvalues( 'true', 'false' )
    munge do |value|
      case value
      when 'true'
        0
      when 'false'
        1
      end
    end
  end

  newproperty(:multiple_events) do
    desc <<-EOT
      Whether the trigger can generate multiple problem events. 

      'false' do not generate multiple events (default); 
      'true'  generate multiple events.
    EOT
    defaultto 'false'
    newvalues( 'true', 'false')
    munge do |value|
      case value
      when 'true'
        1
      when 'false'
        0
      end
    end
  end

  newproperty(:url) do
		#TODO validate URL format
    desc <<-EOT
      URL associated with the trigger.
    EOT
  end

end
