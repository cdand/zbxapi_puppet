Puppet::Type.newtype(:zbx_trigger_action) do

  desc <<-EOT
    zbx_trigger_action is used to manage the Zabbix actions in response to trigger events.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix trigger action'
  end

  newproperty(:actionid) do
    desc '(read-only) ID of the trigger action'
  end

  newproperty(:enabled) do
    desc <<-EOT
      Whether the trigger action is enabled. 

      true  = Trigger action is enabled
      false = Trigger action is disabled
    EOT
    defaultto 'false'
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

  newproperty(:evaluation_type) do
    desc <<-EOT
      Action condition evaluation method. 
      
      AND/OR
      AND
      OR
    EOT
    defaultto 'AND/OR'
    newvalues( 'AND/OR', 'AND', 'OR' )
    munge do |value|
      case value
      when 'AND/OR'
        0
      when 'AND'
        1
      when 'OR'
        2
      end
    end
  end

  newproperty(:step_duration) do
    #TODO validate integer > 60
    desc <<-EOT
      Default operation step duration. Must be greater than 60 seconds.

      Default 3600
    EOT
    defaultto 3600
  end

  newproperty(:default_subject) do
    desc <<-EOT
      Problem message subject.
    EOT
  end

  newproperty(:default_message) do
    desc <<-EOT
      Problem message text.
    EOT
  end

  newproperty(:recovery_subject) do
    desc <<-EOT
      Recovery message subject.
    EOT
  end

  newproperty(:recovery_message) do
    desc <<-EOT
      Recovery message text.
    EOT
  end

  newproperty(:recovery_enabled) do
    desc <<-EOT
      Recovery message enabled.
    EOT
    defaultto 'true'
    newvalues( 'true', 'false' )
    munge do |value|
      case value
      when 'true'
        1
      when 'false'
        0
      end
    end
  end

  newproperty(:operations, :array_matching => :all) do
    desc 'Operations defined for this action'
  end

end
