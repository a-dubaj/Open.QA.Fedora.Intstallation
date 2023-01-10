#!/bin/bash

export release=$(uname -a)
echo "OpenQA on Fedora" 
echo "Running on: $release"

sudo dnf install -y git vim openssh-server openqa openqa-httpd openqa-worker fedora-messaging libguestfs-tools libguestfs-xfs 
python3-fedfind python3-libguestfs libvirt-daemon-config-network libvirt-python3 virt-install withlock postgresql-server fedora-messaging perl-REST-Client

cd /etc/httpd/conf.d/
sudo cp openqa.conf.template openqa.conf
sudo cp openqa-ssl.conf.template openqa-ssl.conf

sudo bash -c "cat >/etc/openqa/openqa.ini <<'EOF'
[global]
branding=plain
download_domains = fedoraproject.org
[auth]
method = Fake
EOF"

sudo postgresql-setup --initdb

sudo systemctl enable --now postgresql
sudo systemctl enable --now httpd
sudo systemctl enable --now openqa-gru
sudo systemctl enable --now openqa-scheduler
sudo systemctl enable --now openqa-websockets
sudo systemctl enable --now openqa-webui
sudo systemctl enable --now fm-consumer@fedora_openqa_scheduler
sudo systemctl enable --now sshd

sudo firewall-cmd --add-port=80/tcp
sudo firewall-cmd --runtime-to-permanent
sudo setsebool -P httpd_can_network_connect 1
sudo systemctl restart httpd

echo "Note! the api key will expire in one day after installation!"

sudo bash -c "cat >/etc/openqa/client.conf <<'EOF'
[localhost]
key = 
secret =  
EOF"

echo "Done! Run sudo ./install-openqa-post.sh"