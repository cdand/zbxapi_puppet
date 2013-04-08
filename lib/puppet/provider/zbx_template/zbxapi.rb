require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet_x', 'zbxapi', 'helper.rb'))

Puppet::Type.type(:zbx_template).provide(:zbxapi) do

  def self.instances
    templates = $zabbix.template.get( 'output' => 'extend' )
    templates.collect do |template|
			new( :name    => template["name"],
          :ensure   => :present,
         )
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

  def create
    $zabbix.template.create( 'name' => resource[:name] )
    @property_hash[:ensure] = :present
  end

  def destroy
    $zabbix.template.delete([@property_hash[:groupid]])
    @property_hash.clear
  end

end
