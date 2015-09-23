# Citrix Linux VDA Puppet Install
Fully automates install and configuration of Citrix Linux VDA from template VM.

## RHEL\CentOS 
1. Installs all required repo packages
2. Adds Linux machine to domain via WinBind
3. Edits or creates any configuration files
4. Installs XenDesktop VDA 1.0.0.161
5. Configures and starts any VDA services

## SUSE
Under development

# Requirements
The following requirements are required for a successful deployment.

## RHEL\CentOS
1. NTP should be configured on the template either manually or via Puppet
2. Hostname should be set on VM
2. On the template VM `/etc/samba/samba.conf` should be renamed to `/etc/samba/samba.conf.bak` to allow required CONF file to be copied down
3. Deployed nodes should be assigned to `ctx_vda` class
4. DNS entry for deployed VM should already be created
5. If Hiera is unavailable edit required variables in the **samba** and **ctx_vda_install** init.pp manifests.  Make sure to comment out hiera variables and uncomment non-hiera.  If hiera is available see `common.yaml` for variable syntax.
6. Download [citrix-linuxvda-rhel-1.0.0.tgz](http://www.citrix.com/downloads/xendesktop/components/linux-virtual-desktop-10.html#ctx-dl-eula) from Citrix and extract **XenDesktopVDA-1.0.0.161-0.x86_64.rpm** into **Files** directory
7. Assumes machine has desktop packages already installed
