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
    $zabbix.usergroup.create( 'name' => resource[:name] )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.usergroup.delete([@property_hash[:usrgrpid]])
    @property_hash.clear
  end

  # Using mk_resource_methods relieves us from having to explicitly write the
  # getters for all properties. I'm not sure yet how this can possibly work
	# for setters though.
  mk_resource_methods 

end
