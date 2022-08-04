# Source: https://github.com/mbaykara/k8s-cluster/blob/main/Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "hashicorp/bionic64"
  config.vm.define "k8s-cp" do | w |
  w.vm.provision "file", source: "./install/kubeadm-config.yaml", destination: "/home/vagrant/kubeadm-config.yaml"
  w.vm.provision "file", source: "./install/calico.yaml", destination: "/home/vagrant/calico.yaml"
  w.vm.provision "file", source: "./install/start-cp.sh", destination: "/home/vagrant/start-cp.sh"
  w.vm.hostname = "k8s-cp"
  w.vm.network "private_network", ip: "192.168.33.13"
  w.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
    vb.name = "k8s-cp"
  end
  w.vm.provision "setup-hosts", :type => "shell", :path => "./install/install.sh" do |s|
  end
  w.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y git wget vim curl
   SHELL
  end

  config.vm.box = "hashicorp/bionic64"
  config.vm.define "k8s-worker-1" do | w |
      w.vm.hostname = "k8s-worker-1"
      w.vm.network "private_network", ip: "192.168.33.14"

      w.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
        vb.name = "worker-1"
      end
      w.vm.provision "setup-hosts", :type => "shell", :path => "./install/install.sh" do |s|
    end
   w.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y git wget vim
   SHELL
  end
  config.vm.box = "hashicorp/bionic64"
  config.vm.define "k8s-worker-2" do | w |
      w.vm.hostname = "k8s-worker-2"
      w.vm.network "private_network", ip: "192.168.33.15"

      w.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
        vb.cpus = 1
        vb.name = "worker-2"
      end
        w.vm.provision "setup-hosts", :type => "shell", :path => "./install/install.sh" do |s|
  end
   w.vm.provision "shell", inline: <<-SHELL
     apt-get update
     apt-get install -y git wget vim curl
   SHELL
  end
end
