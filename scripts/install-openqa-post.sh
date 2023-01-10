#!/bin/bash

cd /var/lib/openqa/tests/
git clone https://pagure.io/fedora-qa/os-autoinst-distri-fedora.git fedora
sudo chown -R geekotest:geekotest fedora
cd fedora

sudo ./fifloder.py -l -c templates.fif.json templates-updates.fif.json

git clone https://pagure.io/fedora-qa/createhdds.git /root/createhdds
sudo mkdir -p /var/lib/openqa/factory/hdd/fixed
sudo mkdir -p /var/lib.openqa/factory/iso/

echo "Cloning job from Fedora Project"
sudo open-clone-job ---from https://openqa.fedoraproject.org/tests/929283
sudo systemctl enable --now openqa-worker@1
echo "Scheduled job should be started by worker"
