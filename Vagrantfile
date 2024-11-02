# Vagrantfile to provision two VMs: log-server and client
Vagrant.configure("2") do |config|
  
  # Define the log-server VM
  config.vm.define "log-server" do |log_server|
    log_server.vm.box = "ubuntu/jammy64" # Ubuntu 22.04 LTS Server
    log_server.vm.hostname = "log-server"
    
    # Set up private network for internal communication
    log_server.vm.network "private_network", ip: "192.168.56.10"
    log_server.vm.network "forwarded_port", guest: 9200, host: 9200

    log_server.ssh.forward_agent    = true
    log_server.ssh.insert_key       = false
    log_server.ssh.private_key_path =  ["~/.vagrant.d/insecure_private_key","logserver.key"]
    log_server.vm.provision :shell, privileged: false do |s|
      ssh_pub_key = File.readlines("logserver.key.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/$USER/.ssh/authorized_keys
        sudo bash -c "echo #{ssh_pub_key} >> /root/.ssh/authorized_keys"
      SHELL
    end
	
    log_server.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
      vb.memory = 4096
    end
    
    # Provision with Ansible
    log_server.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml" # Specify your playbook file
      ansible.groups = {
        "logserver" => ["log-server"],
      }
    end
  end

  # Define the client VM
  config.vm.define "client" do |client|
    client.vm.box = "ubuntu/jammy64"
    client.vm.hostname = "client"
    
    # Same private network for internal communication
    client.vm.network "private_network", ip: "192.168.56.20"    
 
    # Forward the SSH port from client VM to host machine
    client.vm.network "forwarded_port", guest: 22, host: 2223, auto_correct: true

    client.ssh.forward_agent    = true
    client.ssh.insert_key       = false
    client.ssh.private_key_path =  ["~/.vagrant.d/insecure_private_key","client.key"]
    client.vm.provision :shell, privileged: false do |s|
      ssh_pub_key = File.readlines("client.key.pub").first.strip
      s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/$USER/.ssh/authorized_keys
        sudo bash -c "echo #{ssh_pub_key} >> /root/.ssh/authorized_keys"
      SHELL
    end

    client.vm.provider "virtualbox" do |vb|
      vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    end 

    client.vm.provision "ansible", type: "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.groups = {
        "client" => ["client"]
      }
    end

    client.vm.provision "exploit", run: "never", type: "ansible" do |ansible|
      ansible.playbook = "exploit.yml"
      #ansible.verbose = "v"
    end
  end
end


module VagrantPlugins
  module ExploitCommand
    class Command < Vagrant.plugin("2", :command)
      def execute
        target_vm_name = "client"

        with_target_vms(target_vm_name, single_target: true) do |vm|
          @env.ui.info("Running exploit the '#{target_vm_name}' Vagrant machine...")
          
          vm.action(:provision, { provision_types: [:exploit] })
          
          @env.ui.info("Exploit executed successfully on '#{target_vm_name}'.")
        end

        0
      end
    end
  end
end


module VagrantPlugins
  module ExploitCommand
    class Plugin < Vagrant.plugin("2")
      name "Exploit"

      command "exploit" do
        Command
      end
    end
  end
end

