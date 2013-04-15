Puppet::Type.newtype(:zbx_mediatype) do

  desc <<-EOT
    zbx_mediatype is used to manage the Zabbix media types.
  EOT

  ensurable

  newparam(:name, :namevar => true) do
    desc 'The name of the Zabbix media type'
  end

  newproperty(:mediatypeid) do
    desc '(read-only) ID of the media type'
  end

  newproperty(:type) do
    desc <<-EOT
      Transport used by the media type. 

      email      - Connection to SMTP gateway
      script     - Executable script on Zabbix server
      SMS        - SMS via GSM Modem
      Jabber     - Jabber connection
      Ez Texting - Commercial SMS gateway
    EOT
    defaultto 'email'
    newvalues( 'email', 'script', 'SMS', 'Jabber', 'Ez Texting' )
    munge do |value|
      case value
      when 'email'
        0
      when 'script'
        1
      when 'SMS'
        2
      when 'Jabber'
        3
      when 'Ez Texting'
        100
      end
    end
  end

  newproperty(:smtp_server) do
    #TODO check validity of server string
    desc <<-EOT
      SMTP server. 

      Required for email media types.
    EOT
  end

  newproperty(:smtp_helo) do
    desc <<-EOT
      SMTP HELO. 

      Required for email media types.
    EOT
  end

  newproperty(:smtp_email) do
    #TODO check validity of email address
    desc <<-EOT
      Email address from which notifications will be sent. 
      
      Required for email media types.
    EOT
  end

  newproperty(:exec_path) do
    desc <<-EOT
      For script media types exec_path contains the name of the executed script. 

      For Ez Texting exec_path contains the message text limit. 
      Possible text limit values: 
      0 - USA (160 characters); 
      1 - Canada (136 characters). 

      Required for script and Ez Texting media types.
    EOT
    newvalues( 'USA', 'Canada' )
    munge do |value|
      case value
      when 'USA'
        0
      when 'Canada'
        1
      end
    end
  end

  newproperty(:gsm_modem) do
    desc <<-EOT
      Serial device name of the GSM modem. 

      Required for SMS media types.
    EOT
  end

  newproperty(:username) do
    desc <<-EOT
      Username or Jabber identifier. 

      Required for Jabber and Ez Texting media types.
    EOT
  end

  newproperty(:passwd) do
    desc <<-EOT
      Authentication password. 

      Required for Jabber and Ez Texting media types.
    EOT
  end

  newproperty(:enabled) do
    desc <<-EOT
      Whether the media type is enabled. 

      true  = Media type is enabled
      false = Media type is disabled
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

end
