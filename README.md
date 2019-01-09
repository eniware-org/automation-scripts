For deploying CloudFoundry on freshly deployed OpenStack:

bosh_rc - environment variables needed for accessing the BOSH Director

configure-openstack.sh - used for initial OpenStack configuration

download-repos.sh - downloads TerraForm, TerraForm scripts for the second and
                 the third step of the OpenStack configurating procedure,
                 downloads the bosh-deployment and cf-deployment. 
                 generate private key(for BOSH Director access).
                 copy the key to the needed folders.

deploy-bosh-cf.sh - deploys BOSH Director, configure it, deploy CF.

Run configure-openstack.sh and download-repos.sh(doesn't matter which is first).
Run the terraform scripts:
>cd ~/terraform
>cp ../bosh-openstack-environment-templates/bosh-init-tf/terraform.tfvars.template ./terraform.tfvars

Populate the terraforms.tfvars
>terraform init ../bosh-openstack-environment-templates/bosh-init-tf
>terraform apply --auto-approve ../bosh-openstack-environment-templates/bosh-init-tf

This is done to preserve the terraform script output state in case we need it again:
>mv terraform.tfvars bosh_terraform.tfvars
>mv terraform.tfstate bosh_terraform.tfstate
>cp ../bosh-openstack-environment-templates/cf-deployment-tf/terraform.tfvars.template ./terraform.tfvars

Populate the terraforms.tfvars
>terraform init ../bosh-openstack-environment-templates/cf-deployment-tf
>terraform apply --auto-approve ../bosh-openstack-environment-templates/cf-deployment-tf

NB: In our setup the last step managed to create only part of the resources described in the script.
To create all of them repeat the apply step again until the error messages say that the resources are
created and set to the default pool. After that run "terraform show" to get the output of the script.

Preserve the state:
>mv terraform.tfvars cf_terraform.tfvars
>mv terraform.tfstate cf_terraform.tfstate

Populate ~/cf-deployment/iaas-support/openstack/cloud-config-vars.yml

Run the deploy-bosh-cf.sh script

Celebrate if everything went ok.
