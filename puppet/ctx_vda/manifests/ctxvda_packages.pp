class ctx_vda::ctxvda_packages {

	class rhel {
	include stdlib

	#JAVA
	$javapackages = ['java-1.7.0-openjdk','java-1.7.0-openjdk-devel']

	#required version for VDA to work
	package { $javapackages:
		ensure  => '1.7.0.79-2.5.5.4.el6',
		#ensure  => 'present',
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
		command   => "/sbin/service postgresql initdb",
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
	 
	 $oddballs = ['redhat-lsb-core','ImageMagick','policycoreutils-python','libXpm','openmotif']
	 package { $oddballs:
		ensure => 'latest',
		}
	} 
}