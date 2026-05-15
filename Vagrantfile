# -*- mode: ruby -*-
# vi: set ft=ruby :

virt_machines = [
  {
    :hostname => "kukushkina-myu-1",
    :ip => "10.0.1.10"
  },
  {
    :hostname => "kukushkina-myu-2",
    :ip => "10.0.1.11"
  }
]

HOST_SHOW_GUI = false
HOST_MEMORY = "1024"
HOST_CPUS = 1
HOST_BRIDGE = "Intel(R) Wireless-AC 9560"  # измените на ваш адаптер
HOST_VM_BOX = "generic/ubuntu2004"
HOST_CONFIG_SCRIPT = "scripts/zabbix-agent.sh"

HOST_USER = "test"
HOST_USER_PASS = "123456789"
HOST_UPGRADE = "false"
ZABBIX_SERVER_IP = "10.0.1.16"

Vagrant.configure("2") do |config|
  config.vm.box = HOST_VM_BOX
  
  virt_machines.each do |machine|
    config.vm.define machine[:hostname] do |node|
      node.vm.hostname = machine[:hostname]
      node.vm.network :public_network, bridge: HOST_BRIDGE, ip: machine[:ip]
      
      node.vm.provider "virtualbox" do |current_vm, override|
        current_vm.name = machine[:hostname]
        current_vm.gui = HOST_SHOW_GUI
        current_vm.memory = HOST_MEMORY
        current_vm.cpus = HOST_CPUS
        
        override.vm.provision "shell", 
          path: HOST_CONFIG_SCRIPT, 
          args: [
            HOST_USER,
            HOST_USER_PASS,
            HOST_UPGRADE,
            machine[:hostname],
            machine[:ip],
            ZABBIX_SERVER_IP
          ], 
          run: "once"
      end
    end
  end
end
