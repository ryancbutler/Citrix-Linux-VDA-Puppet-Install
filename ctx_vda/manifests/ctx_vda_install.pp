class ctx_vda::ctx_vda_install {

	class rhel {
	##Variables
	#Citrix Desktop Controller LIST
	#ONLY USE IF HIERA UNAVAILABLE
	#$ddc = "ddc.domain.local"

	#Variables from HIERA
	$ddc = hiera('ctx_rhel_vda_install::ddc')

	#Downloads Citrix Linux VDA RPM
	file {'downloadrpm':
		path => '/tmp/XenDesktopVDA-1.0.0.161-0.x86_64.rpm',
		ensure => present,
		source => "puppet:///modules/${module_name}/XenDesktopVDA-1.0.0.161-0.x86_64.rpm",
		}

	#Installs Citrix Linux VDA RPM
	package { 'XenDesktopVDA-1.0.0.161-0.x86_64':
	  ensure   => installed, 
	  provider => 'rpm',
	  source   => 'file:///tmp/XenDesktopVDA-1.0.0.161-0.x86_64.rpm',
	  require => File['downloadrpm'],
	}

	#Pulls down VDA config script from template
	file {'downloadconfvda':
		path => '/tmp/configvda.sh',
		ensure => file,
		content => template("${module_name}/configvda.sh.erb"),
		owner => 'root',
		group => 'root',
		mode  => '0744',
		notify => Exec['configvda'],
		}

	#Service check to see if VDA is configured	
	service { 'ctxvda':
	  ensure     => 'running',
	  enable     => true,
	  hasrestart => true,
	  hasstatus  => true,
	  require => Exec['configvda'],
	}	

	#Configures Citrix VDA service
	 exec { "configvda":
		path      => '/bin:/sbin:/usr/sbin:/usr/bin/',
		command   => "/tmp/configvda.sh",
		unless    => "service ctxvda status",
		user      => 'root',
		group     => 'root',
		logoutput => true,
		require    => [ Package['XenDesktopVDA-1.0.0.161-0.x86_64'], File['downloadconfvda'] ],
		notify => Service['ctxvda'],
	  }
	 } 
}

