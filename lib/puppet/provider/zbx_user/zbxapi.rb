#require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'helper.rb'))
require 'zbxapi'

ZABBIX_URL='http://localhost/'
ZABBIX_USER='admin'
ZABBIX_PASSWD='zabbix'

Puppet::Type.type(:zbx_user).provide(:zbxapi) do

  $zabbix = ZabbixAPI::ZabbixAPI.new(ZABBIX_URL)
  $zabbix.verify_ssl = false
  $zabbix.login(ZABBIX_USER, ZABBIX_PASSWD)

  def self.instances
    users = $zabbix.user.get( 'output' => 'extend', 'selectUsrgrps' => 'extend' )
    users.collect do |user|
      usrgrps = []
      user['usrgrps'].each do |usrgrp|
        usrgrps << usrgrp['name']
      end
      new( :name       => user["alias"],
           :ensure     => :present,
           :userid     => user["userid"],
           :usergroups => usrgrps,
           :firstname  => user["name"],
           :surname    => user["surname"],
           :usertype   => user["type"],
       )
    end
  end

  def self.prefetch(resources)
    users = instances
    resources.keys.each do |name|
      if provider = users.find{ |user| user.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    usrgrpids = $zabbix.usergroup.get( 'output' => 'shorten', 'filter' => {'name' => resource[:usergroups]}).map{ |item| item.values }.flatten
    $zabbix.user.create(
      'alias' => resource[:name],
      'type' => resource[:usertype],
      'name' => resource[:firstname],
      'surname' => resource[:surname],
      'passwd' => 'blah',
      'usrgrps' => usrgrpids,
    )
    @property_hash[:ensure] = :present
    @property_hash[:usertype] = resource[:usertype]
  end

  def destroy
    $zabbix.user.delete("userid" => @property_hash[:userid])
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

  def userid=(value)
    @property_flush['userid'] = value
  end

  def usertype=(value)
    @property_flush['type'] = value
  end

  def firstname=(value)
    @property_flush['name'] = value
  end

  def surname=(value)
    @property_flush['surname'] = value
  end

  def usergroups=(value)
    #FIXME There is some isse with the ordering of usergroups array, if not in usrgrpid numerical order Puppet keeps trying to make a change.
    # Can't quite figure out where this is happening.
    usrgrpids = $zabbix.usergroup.get( 'output' => 'shorten', 'filter' => {'name' => value}).map{ |item| item.values }.flatten
    puts usrgrpids
    @property_flush['usrgrps'] = usrgrpids
  end

  def flush
    unless @property_flush.empty?
			@property_flush['userid'] = @property_hash[:userid]
      $zabbix.user.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end


end
