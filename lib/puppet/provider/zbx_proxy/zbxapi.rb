require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_proxy).provide(:zbxapi) do

  def self.instances
    proxys = $zabbix.proxy.get( 'output' => 'extend', 'selectInterfaces' => 'extend' )
    proxys.collect do |proxy|
      if proxy["interfaces"].empty? then
        new( :name        => proxy["host"],
             :ensure      => :present,
             :proxyid     => proxy["proxyid"],
             :status      => proxy["status"],
             :lastaccess  => proxy["lastaccess"],
					 )
      else
        new( :name        => proxy["host"],
             :ensure      => :present,
             :proxyid     => proxy["proxyid"],
             :status      => proxy["status"],
             :lastaccess  => proxy["lastaccess"],
             :dns         => proxy["interfaces"].first["dns"],
             :ip          => proxy["interfaces"].first["ip"],
             :port        => proxy["interfaces"].first["port"],
             :useip       => proxy["interfaces"].first["useip"],
             :interfaceid => proxy["interfaces"].first["interfaceid"],
             :hostid      => proxy["interfaces"].first["hostid"],
        )
  		end
    end
  end

  def self.prefetch(resources)
    proxys = instances
    resources.keys.each do |name|
      if provider = proxys.find{ |proxy| proxy.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.proxy.create( 'host' => resource[:name],
											 	  'status' => resource[:status],
												  'interfaces' => [{'ip' => resource[:ip], 'dns' => resource[:dns], 'port' => resource[:port], 'useip' => resource[:useip]}] )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.proxy.delete([@property_hash[:proxyid]])
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
		@property_flush['interfaces'] = [{}]
  end

	def status=(value)
    @property_flush['status'] = value
	end

  def ip=(value)
    @property_flush['interfaces'].first['ip'] = value
  end

  def dns=(value)
    @property_flush['interfaces'].first['dns'] = value
  end

  def port=(value)
    @property_flush['interfaces'].first['port'] = value
  end

  def useip=(value)
    @property_flush['interfaces'].first['useip'] = value
  end

  def flush
		# FIXME Currently can't convert a passive proxy back to an active proxy because the interfaces array is empty.
    unless @property_flush['interfaces'].first.empty?
			@property_flush['proxyid'] = @property_hash[:proxyid]
      $zabbix.proxy.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end


end
