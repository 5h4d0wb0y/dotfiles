Vagrant.configure("2") do |config|

    config.vm.synced_folder "", "/home/vagrant/dotfiles"

    #config.vm.provision :shell, path: "install.sh"

    config.vm.define "test1" do |cfg|
        cfg.vm.box = "debian/stretch64"
        cfg.vm.provider "virtualbox" do |vb, override|
            vb.name = "test1"
            vb.customize ["modifyvm", :id, "--memory", 2048]
            vb.customize ["modifyvm", :id, "--cpus", 1]
            vb.customize ["modifyvm", :id, "--vram", "16"]
            vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
            vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
            vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
            vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
        end
    end

    config.vm.define "test2" do |cfg|
        cfg.vm.box = "ubuntu/bionic64"
        cfg.vm.provider "virtualbox" do |vb, override|
            vb.name = "test2"
            vb.customize ["modifyvm", :id, "--memory", 2048]
            vb.customize ["modifyvm", :id, "--cpus", 1]
            vb.customize ["modifyvm", :id, "--vram", "16"]
            vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
            vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
            vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
            vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
        end
    end
end