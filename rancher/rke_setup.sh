echo "Setting up Docker"
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

sudo usermod -aG docker $USER

echo "Setting up disks"
lsblk

printf "Which disk to use for docker storage?\n> "
read DOCKER_DISK
sudo parted $DOCKER_DISK mklabel gpt
sudo parted -a optimal $DOCKER_DISK mkpart primary 0% 100%
sleep 5
sudo mkfs.ext4 ${DOCKER_DISK}1
sudo mkdir /docker
sudo mount ${DOCKER_DISK}1 /docker

printf "{\n\t\"data-root\":\"/docker\"\n}" | sudo tee /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo service docker restart

echo "Setting up RKE dependencies"
for module in br_netfilter ip6_udp_tunnel ip_set ip_set_hash_ip ip_set_hash_net iptable_filter iptable_nat iptable_mangle iptable_raw nf_conntrack_netlink nf_conntrack nf_conntrack_ipv4   nf_defrag_ipv4 nf_nat nf_nat_ipv4 nf_nat_masquerade_ipv4 nfnetlink udp_tunnel veth vxlan x_tables xt_addrtype xt_conntrack xt_comment xt_mark xt_multiport xt_nat xt_recent xt_set  xt_statistic xt_tcpudp;
    do
      sudo modprobe $module;
    done

sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.ipv4.ip_forward=1

echo "AllowTcpForwarding yes" | sudo tee -a /etc/ssh/sshd_config

echo "Relog to shell to update user groups."