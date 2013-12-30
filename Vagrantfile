VAGRANTFILE_API_VERSION = "2"
SYNCED_FOLDER           = "~/Projetos/apps"

BOX_32                  = "precise32"
BOX_URL_32              = "http://files.vagrantup.com/precise32.box"
BOX_64                  = "precise64"
BOX_URL_64              = "http://files.vagrantup.com/precise64.box"

nodes = [
  { hostname: "oracle",     ip: "192.168.33.10", memory: "2048", box: BOX_64, box_url: BOX_URL_64 },
  { hostname: "postgresql", ip: "192.168.33.11", memory: "512",  box: BOX_32, box_url: BOX_URL_32 },
  { hostname: "mysql",      ip: "192.168.33.12", memory: "512",  box: BOX_32, box_url: BOX_URL_32 },
  { hostname: "ruby",       ip: "192.168.33.13", memory: "512",  box: BOX_32, box_url: BOX_URL_32 }
]

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|

      node_config.vm.box       = node[:box]
      node_config.vm.box_url   = node[:box_url]
      node_config.vm.hostname  = node[:hostname]

      node_config.vm.network :private_network, ip: node[:ip]
      node_config.vm.synced_folder SYNCED_FOLDER, "/apps"

      node_config.vm.provider "virtualbox" do |vb|
        vb.customize [ "modifyvm", :id, "--name", node[:hostname], "--memory", node[:memory]]
      end

      node_config.vm.provision :puppet do |puppet|
        puppet.options        = "--verbose --summarize --debug"
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path    = "puppet/modules"
      end

    end
  end
end
