cd ~
sudo add-apt-repository cloud-archive:rocky -y
sudo apt-get update
sudo apt-get install python-novaclient python-keystoneclient python-glanceclient python-neutronclient python-openstackclient -y
source openstack-bundles/stable/openstack-base/openrc
wget https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img
openstack image create --public --min-disk 3 --container-format bare --disk-format qcow2 --property architecture=x86_64 \
--property hw_disk_bus=virtio --property hw_vif_model=virtio --file bionic-server-cloudimg-amd64.img "bionic x86_64"
openstack flavor create --vcpus 1 --ram 3840 --disk 3 --ephemeral 10 minimal
openstack flavor create --vcpus 2 --ram 7680 --disk 3 --ephemeral 14 small
openstack flavor create --vcpus 2 --ram 7680 --disk 3 --ephemeral 50 small-50GB-ephemeral-disk
openstack flavor create --vcpus 4 --ram 31232 --disk 3 --ephemeral 10 small-highmem
openstack flavor create --vcpus 4 --ram 31232 --disk 3 --ephemeral 100 small-highmem-100GB-ephemeral-disk
openstack flavor create --vcpus 8 --ram 16384 --disk 160 --ephemeral 0 m1.xlarge
openstack domain create cf_domain
openstack project create cloudfoundry --domain cf_domain
openstack user create eniware --domain cf_domain --project cloudfoundry --password Eniware8
openstack role add --project cloudfoundry --project-domain cf_domain --user eniware --user-domain cf_domain Member
cd openstack-bundles/stable/openstack-base/
./neutron-ext-net-ksv3 --network-type flat -g 192.168.40.1 -c 192.168.40.0/24 -f 192.168.40.190:192.168.40.254 ext_net
#compute quotas set
openstack quota set --instances 100 --cores 96 --ram 153600 --key-pairs 100 cloudfoundry
#volume quotas set
openstack quota set --volumes 100 --per-volume-gigabytes 500 --gigabytes 4096 cloudfoundry
#network quotas set
openstack quota set --secgroup-rules 100 --secgroups 100 --networks 500 --subnets 1000 --ports 2000 --routers 1000 --vips 100 --subnetpools 500 cloudfoundry
