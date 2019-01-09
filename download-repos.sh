cd ~
#install terraform
sudo apt-get update
sudo apt-get install -y git unzip
wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip
unzip terraform_0.11.11_linux_amd64.zip
chmod +x terraform
sudo mv terraform /usr/local/bin/

#setup for the terraform scripts
git clone https://github.com/eniware-org/bosh-openstack-environment-templates/
mkdir terraform
./bosh-openstack-environment-templates/bosh-init-tf/generate_ssh_keypair.sh
mv bosh.* terraform/

# copy the template file from bosh-init-tf and populate it
# terraform init 
#terraform apply

# the same things for cf-deployment-tf

#install bosh cli
wget https://github.com/cloudfoundry/bosh-cli/releases/download/v5.4.0/bosh-cli-5.4.0-linux-amd64
chmod +x bosh-cli-5.4.0-linux-amd64
sudo mv bosh-cli-5.4.0-linux-amd64 /usr/local/bin/bosh

#dependencies for bosh create-env
#for xenial:
#sudo apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3
#for bionic:
sudo apt-get install -y libtinfo-dev  => the package is dependancy for installation of libreadline6-dev

wget http://archive.ubuntu.com/ubuntu/pool/main/r/readline6/libreadline6_6.3-8ubuntu2_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/main/r/readline6/libreadline6-dev_6.3-8ubuntu2_amd64.deb
sudo dpkg -i libreadline6_6.3-8ubuntu2_amd64.deb
sudo dpkg -i libreadline6-dev_6.3-8ubuntu2_amd64.deb
sudo apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3


#create a folder to save the BOSH state; copy the public key needed for the BOSH VM access;

mkdir bosh-1
cp terraform/bosh.pem ./bosh-1/
cd bosh-1
git clone https://github.com/cloudfoundry/bosh-deployment

cd ..
git clone https://github.com/cloudfoundry/cf-deployment

#deploy the BOSH Director; set the env vars; upload cloud config;
#upload runtime config for DNS and interpolate the needed certificates from BOSH
#upload stemcell
#deploy CloudFoundry
#PROFIT!
