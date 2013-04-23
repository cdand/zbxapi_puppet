Puppet::Type.newtype(:zbx_template_triggerprototype) do

  desc <<-EOT
    zbx_template_trigger is used to manage Zabbix template triggers.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc 'Name of the trigger prototype'
  end

  newproperty(:triggerid) do
    desc '(read-only) ID of the trigger prototype'
  end

  newproperty(:hostid) do
    desc <<-EOT
      (read-only) ID of the template
    EOT
  end

  newproperty(:ruleid) do
    desc <<-EOT
      (read-only) ID of the template parent discovery rule
    EOT
  end

  newproperty(:expression) do
		#TODO validate format of expression
    desc <<-EOT
      Reduced trigger expression.

      The API is automatically able to determine which template the trigger
      prototype should belong to by evaluating the template name in the expression.
    EOT
  end

  newproperty(:comments) do
    desc <<-EOT
      Additional comments to the trigger.
    EOT
  end

  newproperty(:priority) do
    desc <<-EOT
      Severity of the trigger prototype. 
      
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
      Whether the trigger prototype is enabled or disabled. 

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
      Whether the trigger prototype can generate multiple problem events. 

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
      URL associated with the trigger prototype.
    EOT
  end

end
