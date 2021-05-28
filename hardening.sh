#!/bin/bash
sudo yum install epel-release -y
sudo yum install ansible -y
sudo yum install git -y
sudo git clone https://github.com/corestacklabs/Scripts.git
cd Scripts/Ansible_Hardening
sudo tar -xzf RHEL7-CIS.tar.gz
sudo ansible-playbook Hardening.yaml -i localhost -c local

sudo sed -i '$d' /etc/hosts.allow
sudo sed -i '$d' /etc/hosts.deny
sudo sed 's/PasswordAuthentication yes/PasswordAuthentication no/' -i /etc/ssh/sshd_config

#sudo reboot
