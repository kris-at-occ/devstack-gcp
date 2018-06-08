# Prepare the system

DEBIAN_FRONTEND=noninteractive sudo apt-get -y update
DEBIAN_FRONTEND=noninteractive sudo apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y crudini git
externalip=$(curl -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
novncproxy_base_url="http://$externalip:6080/vnc_auto.html"

# Clone devstack repo

git clone https://git.openstack.org/openstack-dev/devstack

cd devstack

# Prepare 'local.conf'
cat <<- EOF > local.conf
[[local|localrc]]
ADMIN_PASSWORD=openstack
DATABASE_PASSWORD=openstack
RABBIT_PASSWORD=openstack
SERVICE_PASSWORD=openstack

enable_plugin heat https://git.openstack.org/openstack/heat

enable_service s-proxy s-object s-container s-account
SWIFT_HASH=66a3d6b56c1f479c8b4e70ab5c2000f5
SWIFT_REPLICAS=1
SWIFT_DATA_DIR=$DEST/data/swift

[[post-config|$NOVA_CPU_CONF]]
[vnc]
novncproxy_base_url=$novncproxy_base_url
EOF

$ ./stack.sh

echo "You can access Horizon Dashboard at External IP address: http://$externalip/dashboard"
