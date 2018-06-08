# devstack-gcp
Scripts to install Devstack in GCP Virtual Machine

In GCP Console go to VPC Network -> Firewall rules
+ Create Firewall Rule
- Name: allownovnc
- Ingress
- Allow
- Targets: All Instances
- Source IP ranges: 0.0.0.0/0
- Protocols and Ports: tcp/6080

In Compute Engine Create a new VM
- Name: devstack
- Region: most suitable
- Machine type: 2 vCPUs n1-standard-2
- Boot disk: Ubuntu 16.04, 30GB disk (Standard or SSD)
- Firewall: Allow HTTP and HTTPS traffic
- SSH Key (if you like)

Open SSH console and clone this repo:

git clone https://github.com/kris-at-occ/devstack-gcp

Run script to install Devstack with Pike:

sh devstack-gcp/devstack-pike.sh

Run script to install Devstack with latest master:

sh devstack-gcp/devstack-latest.sh

Enjoy!
