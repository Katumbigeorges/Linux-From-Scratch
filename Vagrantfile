# LFS Build Environment Configuration
IMAGE = "generic/ubuntu2004"
MEM = 4096
CPU = 3
DISK_NAME = "linux.vdi"
DISK_SIZE = 30 * 1024
VNAME = "LFS-Build"
VIP = "192.168.42.110"

# Build configuration
BUILD_TIMEOUT = 7200  # 2 hours timeout for builds

Vagrant.configure("2") do |config|

	config.vm.define VNAME do |master|
		master.vm.box = IMAGE
		master.vm.hostname = VNAME
		master.vm.network :private_network, ip: VIP
		master.vm.provider "virtualbox" do |v|
			v.name = VNAME
			v.memory = MEM
			v.cpus = CPU
			v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
			v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
			v.customize ["modifyvm", :id, "--audio", "none"]
			unless FileTest.exist?(DISK_NAME)
				v.customize ['createhd', '--filename', DISK_NAME, '--format', 'VDI', '--size', DISK_SIZE]
			end
  			v.customize ['storageattach', :id, '--storagectl', 'IDE Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', DISK_NAME]
		end
		master.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/tmp/id_rsa.pub"
		master.vm.provision "file", source: "./wget-list", destination: "~/wget-list"
		master.vm.provision "file", source: "./sources", destination: "/tmp/sources"
		master.vm.provision "file", source: "./linux.sh", destination: "~/linux.sh"
		master.vm.provision "file", source: "./linux2.sh", destination: "~/linux2.sh"
		master.vm.provision "file", source: "./linux2.sh", destination: "~/linux3.sh"
		master.vm.provision "shell", privileged: true, inline: "cp /home/vagrant/* ~/ && mkdir ~/.ssh && cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys"
		# Build Phase 1: Initial setup and partitioning
		master.trigger.after :up do |trigger|
            trigger.name = "Phase 1: Initial Setup"
            trigger.run = {
                "inline": "ssh -o ConnectTimeout=#{BUILD_TIMEOUT} -o StrictHostKeyChecking=no root@#{VIP} 'bash -s -- uno < ~/ft_linux.sh'"
            }
            trigger.on_error = :halt
		end
		
		# Build Phase 2: Cross-toolchain
		master.trigger.after :up do |trigger|
            trigger.name = "Phase 2: Cross-Toolchain"
            trigger.run = {
                "inline": "ssh -o ConnectTimeout=#{BUILD_TIMEOUT} -o StrictHostKeyChecking=no lfs@#{VIP} 'cat ~/ft_linux2.sh | exec env -i HOME=$HOME TERM=$TERM PS1=\u:\w\$\  /bin/bash'"
            }
            trigger.on_error = :halt
		end
		
		# Build Phase 3: Final system
		master.trigger.after :up do |trigger|
            trigger.name = "Phase 3: Final System"
            trigger.run = {
                "inline": "ssh -o ConnectTimeout=#{BUILD_TIMEOUT} -o StrictHostKeyChecking=no root@#{VIP} 'bash -s -- uno < ~/ft_linux3.sh'"
            }
            trigger.on_error = :halt
		end
	end

end
