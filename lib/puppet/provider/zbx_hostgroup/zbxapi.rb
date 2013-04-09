require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_hostgroup).provide(:zbxapi) do

  def self.instances
    hostgroups = $zabbix.hostgroup.get( 'output' => 'extend', 'selectHosts' => 'extend' )
    hostgroups.collect do |hostgroup|
      new( :name    => hostgroup["name"],
           :ensure   => :present,
           :groupid  => hostgroup["groupid"],
           :internal => hostgroup["internal"],
           :hosts    => hostgroup["hosts"],
      )
    end
  end

  def self.prefetch(resources)
    hostgroups = instances
    resources.keys.each do |name|
      if provider = hostgroups.find{ |hostgroup| hostgroup.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.hostgroup.create( 'name' => resource[:name] )
    @property_hash[:ensure] = :present
  end

  def destroy
    # FIXME This could be made more efficient by sending a list of hostid to be deleting in one API request.
    # FIXME I suspect this has a problem when applied via a resources { 'zbx_hostgroup': purge => true }, unless there is a way to know how the destroy was invoked.
    if resource[:purge] == :true then
      @property_hash[:hosts].each do |host|
        $zabbix.host.delete("hostid" => host["hostid"])
        Puppet.notice( resource.to_s + " - Purge Zabbix Host => " + host["host"] + " [" + host["hostid"] + "]")
      end
    end
    $zabbix.hostgroup.delete([@property_hash[:groupid]])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the
  # getters for 'groupid' and 'internal' properties (left commented below). I'm
  # not sure yet how this can possibly work for setters though.
  #
  #  def groupid
  #		@property_hash[:groupid]
  #  end
  #
  #  def internal
  # 		@property_hash[:internal]
  #  end
  mk_resource_methods

end
