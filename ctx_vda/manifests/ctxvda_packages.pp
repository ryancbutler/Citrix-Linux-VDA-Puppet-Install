class ctx_vda::ctxvda_packages {

	class rhel {
	include stdlib

	#JAVA
	$javapackages = ['java-1.7.0-openjdk','java-1.7.0-openjdk-devel']

	#OS Version Differences
	if $operatingsystemmajrelease == '6' {
	$oddballs = ['redhat-lsb-core','ImageMagick','policycoreutils-python','libXpm','openmotif']
	$postgresinit = '/sbin/service postgresql initdb'
	}
	elsif $operatingsystemmajrelease == '7' {
	$oddballs = ['redhat-lsb-core','ImageMagick','policycoreutils-python','libXpm','motif']
	$postgresinit = 'postgresql-setup initdb'
	}
	

	package { $javapackages:
		ensure  => 'present',
	  }

	#This breaks the VDA from connecting
	#  file_line { 'JAVAHOME':
	#   path => '/root/.bashrc',
	#   line => 'JAVA_HOME=/usr/lib/jvm/java',
	#} 

	#Installs Postgress and initializes
	$postgresspackages = ['postgresql-server','postgresql','postgresql-devel','postgresql-jdbc']

	package { $postgresspackages:
		ensure => 'latest',
		}

	#initialize the postrgres DB
	  exec { 'initpostgres':
		path      => '/bin:/sbin:/usr/sbin:/usr/bin/',
		creates => '/var/lib/pgsql/data/PG_VERSION',
		command   => $postgresinit,
		user      => 'root',
		group     => 'root',
		logoutput => true,
		notify => Service['postgresql'],
	  }

	 #make sure service is running 
	  service { 'postgresql':
		ensure     => 'running',
		enable     => true,
		hasrestart => true,
		hasstatus  => true,
		require => Exec['initpostgres'],
		}

	 #remaining packages needed for VDA install
	 package { $oddballs:
		ensure => 'latest',
		}
	} 
}