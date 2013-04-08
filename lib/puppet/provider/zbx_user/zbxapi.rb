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
    users = $zabbix.user.get( 'output' => 'extend' )
    users.collect do |user|
    new( :name      => user["alias"],
         :ensure    => :present,
         :userid    => user["userid"],
         :usergroup => user["usrgrpid"],
         :firstname => user["name"],
         :surname   => user["surname"],
         :usertype  => user["type"],
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
    $zabbix.user.create(
      'alias' => resource[:name],
      'type' => resource[:usertype],
      'name' => resource[:firstname],
      'surname' => resource[:surname],
      'passwd' => 'blah',
      'usrgrps' => [{'usrgrpid' => '7'}]
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

  def flush
    unless @property_flush.empty?
			@property_flush['userid'] = @property_hash[:userid]
      $zabbix.user.update( @property_flush )
    end
    @property_hash = resource.to_hash
  end


end
