class ctx_vda::samba {

class rhel {
#Adds RHEL machine to the domain

#Variables
#ONLY USE IF HIERA UNAVAILABLE
  #$adminuser = 'ADMINUSER'
  #$adminpassword = 'PASSWORD'
  #$domain_controller = 'DC01.DOMAIN.LOCAL'
  #$active_directory_realm = "DOMAIN.LOCAL"
  #$domainworkgroup = "DOMAIN"

#Variables from HIERA
  $adminuser = hiera('samba::rhel::adminuser')
  $adminpassword = hiera('samba::rhel::adminpassword')
  $domain_controller = hiera('samba::rhel::domain_controller')
  $active_directory_realm = hiera('samba::rhel::active_directory_realm')
  $domainworkgroup = hiera('samba::rhel::domainworkgroup')
  
  
  # Verify Winbind and Kerberos are installed
  $packagelist = ['samba-winbind','krb5-workstation']


  package { $packagelist:
    ensure  => 'latest',
  }
 
 
  file { '/etc/security/pam_winbind.conf':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/pam_winbind.conf.erb"),
    require => Package['samba-winbind'],
    notify  => Service['winbind'],
  }

  # We aren't using file sharing services
  service { 'smb':
    ensure     => 'stopped',
    enable     => false,
    hasrestart => true,
    hasstatus  => true,
  }


  service { 'winbind':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => File['smbconf'],
  }

	
  file { 'smbconf':
    path => '/etc/samba/smb.conf',
	ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['samba-winbind'],
	content => template("${module_name}/smb.conf${operatingsystemmajrelease}.erb"),
    notify  => Service['winbind'],
	replace => false,
  }
  

exec { "configurewinbind":
	path      => '/bin:/sbin:/usr/sbin:/usr/bin/',
    unless    => 'net ads testjoin',
    command   => "authconfig \
--disablecache \
--disablesssd \
--disablesssdauth \
--enablewinbind \
--enablewinbindauth \
--disablewinbindoffline \
--smbsecurity=ads \
--smbworkgroup=${domainworkgroup} \
--smbrealm=${active_directory_realm} \
--winbindtemplatehomedir=/home/%D/%U \
--winbindtemplateshell=/bin/bash \
--krb5realm=${active_directory_realm} \
--krb5kdc=${domain_controller} \
--krb5adminserver=${domain_controller} \
--enablelocauthorize \
--enablemkhomedir \
--update",
    user      => 'root',
    group     => 'root',
    logoutput => true,
    notify    => Service[winbind],
  }


#ugly workaround for authconfig created line for CentOS 7
file_line { 'authconfig_fix':
  path => '/etc/samba/smb.conf',  
  line => '   kerberos method = secrets and keytab',
  match => '^\s*kerberos method = secrets only*$',
  } ~> 
 exec { "join-AD-domain": # Try joining to the domain if it's not correctly showing it's joined
    path      => '/bin:/sbin:/usr/sbin:/usr/bin/',
    unless    => 'net ads testjoin',
    command   => "net ads join -U ${adminuser}%${adminpassword} -S ${domain_controller}",
    user      => 'root',
    group     => 'root',
    logoutput => true,
    notify    => Service[winbind],
	require => Exec['configurewinbind'],
  }

  
}
}


