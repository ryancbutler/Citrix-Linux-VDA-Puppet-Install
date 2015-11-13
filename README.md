# Citrix Linux VDA Puppet Install
Fully automates install and configuration of Citrix Linux VDA from template VM. Basically follows this guide http://blogs.citrix.com/2015/08/25/installing-the-linux-vda-on-red-hat-or-centos-6/

## RHEL\CentOS 
1. Installs all required repo packages
2. Adds Linux machine to domain via WinBind
3. Edits or creates any configuration files
4. Installs XenDesktop VDA 1.1.0.240
5. Configures and starts any VDA services

## SUSE
Under development

## Install

### RHEL\CentOS with Puppet-Master
1. NTP should be configured on the template either manually or via Puppet
2. On the template VM `/etc/samba/smb.conf` should be renamed to `/etc/samba/smb.conf.bak` to allow required CONF file to be copied down
3. Deployed nodes should be assigned to `ctx_vda` class
4. If Hiera is unavailable edit required variables in the **samba** and **ctx_vda_install** init.pp manifests.  Make sure to comment out hiera variables and uncomment non-hiera.  If hiera is available see `common.yaml` for variable syntax.
5. Download the Citrix Linuxvda either for version 6 or 7 from Citrix and extract **XenDesktopVDA-1.1.0.240** into **Files** directory as **XenDesktopVDA6-1.1.0.240-0.x86_64.rpm** or **XenDesktopVDA7-1.1.0.240-0.x86_64.rpm** (note the 6 or 7 after VDA).  The file names must be renamed to match the OS version.
6. Assumes machine has desktop packages already installed

### RHEL\CentOS with NO Puppet-Master
1. NTP should be configured. `nano /etc/ntp.conf`
2. Rename **smb.conf** to allow template to be copied. `mv /etc/samba/smb.conf /etc/samba/smb.conf.bak`
3. Login as root and make sure to be at home directory `cd /root`
4. Install puppet and git `yum install puppet git -y`
5. Clone git repo. `git clone https://github.com/ryancbutler/Citrix-Linux-VDA-Puppet-Install.git`
6. Download citrix-linuxvda either for version 6 or 7 from Citrix and extract **XenDesktopVDA-1.1.0.240** into **Files** directory as **XenDesktopVDA6-1.1.0.240-0.x86_64.rpm** or **XenDesktopVDA7-1.1.0.240-0.x86_64.rpm**.  The names must be renamed to match the OS version.
7. Edit common.yaml to reflect environment variables. `nano /root/Citrix-Linux-VDA-Puppet-Install/common.yaml`
8. Run puppet `puppet apply --pluginsync --hiera_config /root/Citrix-Linux-VDA-Puppet-Install/common.yaml /root/Citrix-Linux-VDA-Puppet-Install/ctx_vda/manifests/init.pp`
