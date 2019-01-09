bosh create-env bosh-deployment/bosh.yml --state=bosh-state.json --vars-store=director-creds.yml --vars-file=vars.yml -o bosh-deployment/openstack/cpi.yml -o bosh-deployment/external-ip-with-registry-not-recommended.yml -o bosh-deployment/local-dns.yml --var-file=private_key=bosh.pem

bosh alias-env bosh-1 -e 192.168.40.196 --ca-cert <(bosh int director-creds.yml --path /director_ssl/ca)

source bosh_rc

bosh -e bosh-1 login

bosh -e bosh-1 update-cloud-config ../cf-deployment/iaas-support/openstack/cloud-config.yml --vars-file ../cf-deployment/iaas-support/openstack/cloud-config-vars.yml

bosh -e bosh-1 update-runtime-config <(bosh int ../bosh-1/bosh-deployment/runtime-configs/dns.yml --vars-store deployment-vars.yml) --name dns

bosh -e bosh-1 upload-stemcell https://bosh.io/d/stemcells/bosh-openstack-kvm-ubuntu-xenial-go_agent?v=170.9

cd ../cf-deployment

bosh -e bosh-1 -d cf deploy cf-deployment.yml -o operations/use-compiled-releases.yml -o operations/scale-to-one-az.yml -o operations/openstack.yml \
--vars-store deployment-vars.yml -v system_domain="eniware.org" -v cf_admin_password="password" -v uaa_admin_client_secret="password"
