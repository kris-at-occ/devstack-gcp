# Prepare the system

DEBIAN_FRONTEND=noninteractive sudo apt-get -y update
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y crudini git

# Clone devstack repo

git clone https://git.openstack.org/openstack-dev/devstack -b stable/newton

sed -i -e 's/pip_version<6/pip_version<0/g' devstack/inc/python
externalip=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

cd devstack

# Prepare 'local.conf'
cat <<- EOF > local.conf
[[local|localrc]]
ADMIN_PASSWORD=openstack
DATABASE_PASSWORD=openstack
RABBIT_PASSWORD=openstack
SERVICE_PASSWORD=openstack
enable_service s-proxy s-object s-container s-account
enable_service h-eng h-api h-api-cfn h-api-cw
SWIFT_HASH=66a3d6b56c1f479c8b4e70ab5c2000f5
SWIFT_REPLICAS=1
SWIFT_DATA_DIR=$DEST/data/swift
[[post-config|$NOVA_CONF]]
[vnc]
novncproxy_base_url="http:///$externalip:6080/vnc_auto.html"
EOF

./stack.sh

echo "You can access Horizon Dashboard at External IP address: http://$externalip/dashboard"
