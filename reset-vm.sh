# cleanup current ssh keys so templated VMs get fresh key
sudo rm -f /etc/ssh/ssh_host_*

# add check for ssh keys on reboot...regenerate if neccessary
sudo tee /etc/rc.local >/dev/null <<EOL
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#

# By default this script does nothing.
test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL

# make the script executable
sudo chmod +x /etc/rc.local

# cleanup apt
sudo apt clean

# reset the machine-id (DHCP leases in 18.04 are generated based on this... not MAC...)
echo "" | sudo tee /etc/machine-id >/dev/null

# disable swap for K8s
sudo swapoff --all
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

# cleanup shell history and shutdown for templating
history -c
history -w
sudo shutdown -h now
