require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_mediatype).provide(:zbxapi) do

  def self.instances
    mediatypes = $zabbix.mediatype.get( 'output' => 'extend' )
    mediatypes.collect do |mediatype|
      new( :name        => mediatype["description"],
           :ensure      => :present,
           :mediatypeid => mediatype["mediatypeid"],
           :type        => mediatype["type"],
           :smtp_server => mediatype["smtp_server"],
           :smtp_helo   => mediatype["smtp_helo"],
           :smtp_email  => mediatype["smtp_email"],
           :exec_path   => mediatype["exec_path"],
           :gsm_modem   => mediatype["gsm_modem"],
           :username    => mediatype["username"],
           :passwd      => mediatype["passwd"],
           :enabled     => mediatype["status"],
      )
    end
  end

  def self.prefetch(resources)
    mediatypes = instances
    resources.keys.each do |name|
      if provider = mediatypes.find{ |mediatype| mediatype.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.mediatype.create( 'description' => resource[:name],
                              'type'        => resource[:type],
                              'smtp_server' => resource[:smtp_server],
                              'smtp_helo'   => resource[:smtp_helo],
                              'smtp_email'  => resource[:smtp_email],
                              'exec_path'   => resource[:exec_path],
                              'gsm_modem'   => resource[:gsm_modem],
                              'username'    => resource[:username],
                              'passwd'      => resource[:passwd],
                              'status'      => resource[:enabled],)
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.mediatype.delete([@property_hash[:mediatypeid]])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the
  # getters for all properties. I'm not sure yet how this can possibly work
	# for setters though.
  mk_resource_methods 

  # Despite Puppet Labs docs, it would appear mk_resource methods is only
  # useful for getters. We need to create all the different setters.
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def type=(value)
    @property_flush['type'] = value
  end

  def smtp_server=(value)
    @property_flush['smtp_server'] = value
  end

  def smtp_helo=(value)
    @property_flush['smtp_helo'] = value
  end

  def smtp_email=(value)
    @property_flush['smtp_email'] = value
  end

  def exec_path=(value)
    @property_flush['exec_path'] = value
  end

  def gsm_modem=(value)
    @property_flush['gsm_modem'] = value
  end

  def username=(value)
    @property_flush['username'] = value
  end

  def passwd=(value)
    @property_flush['passwd'] = value
  end

  def enabled=(value)
    @property_flush['status'] = value
  end

  def flush
    unless @property_flush.empty?
      @property_flush['mediatypeid'] = @property_hash[:mediatypeid]
      $zabbix.mediatype.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end

end
