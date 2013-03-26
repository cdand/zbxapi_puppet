#require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'helper.rb'))
require 'zbxapi'

ZABBIX_URL='http://localhost/'
ZABBIX_USER='admin'
ZABBIX_PASSWD='zabbix'

Puppet::Type.type(:zbx_usergroup).provide(:zbxapi) do

  $zabbix = ZabbixAPI::ZabbixAPI.new(ZABBIX_URL)
  $zabbix.verify_ssl = false
  $zabbix.login(ZABBIX_USER, ZABBIX_PASSWD)

  def self.instances
    usergroups = $zabbix.usergroup.get( 'output' => 'extend' )
    usergroups.collect do |usergroup|
			new( :name            => usergroup["name"],
          :ensure           => :present,
          :usrgrpid         => usergroup["usrgrpid"],
          :authentication   => usergroup["gui_access"],
          :enabled          => usergroup["users_status"],
          :debug            => usergroup["debug_mode"],
         )
    end
  end

  def self.prefetch(resources)
    usergroups = instances
    resources.keys.each do |name|
      if provider = usergroups.find{ |usergroup| usergroup.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.usergroup.create( 'name' => resource[:name], 'gui_access' => resource[:authentication], 'users_status' => resource[:enabled], 'debug_mode' => resource[:debug] )
    @property_hash[:ensure]         = :present
    @property_hash[:authentication] = resource[:authentication]
    @property_hash[:enabled]        = resource[:enabled]
    @property_hash[:debug]          = resource[:debug]
  end

  def destroy
    $zabbix.usergroup.delete([@property_hash[:usrgrpid]])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the
  # getters for all properties. I'm not sure yet how this can possibly work
	# for setters though.
  mk_resource_methods 

	# Despite Puppet Labs docs, it would appear mk_resource methods is only
	# useful for getters. We need to create all the different setters.
  def authentication=(value)
    $zabbix.usergroup.update( 'usrgrpid' => @property_hash[:usrgrpid], 'gui_access' => resource[:authentication] )
		@property_hash[:authentication] = value
  end

  def enabled=(value)
    $zabbix.usergroup.update( 'usrgrpid' => @property_hash[:usrgrpid], 'users_status' => resource[:enabled] )
		@property_hash[:enabled] = value
  end

  def debug=(value)
    $zabbix.usergroup.update( 'usrgrpid' => @property_hash[:usrgrpid], 'debug_mode' => resource[:debug] )
		@property_hash[:debug] = value
  end

end
