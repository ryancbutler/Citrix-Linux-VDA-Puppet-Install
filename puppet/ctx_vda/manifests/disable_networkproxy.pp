class ctx_vda::disable_networkproxy {

	class rhel {
	#Creates needed directory if not there
	file { '30-site.d':
		path => '/etc/polkit-1/localauthority/30-site.d',
		ensure  => 'directory',
	  }

	#Copies down file.  See installation guide for more information.  
	file { 'proxydialog':
		path => '/etc/polkit-1/localauthority/30-site.d/20-no-show-proxy-dialog.pkla',
		ensure  => 'file',
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template("${module_name}/20-no-show-proxy-dialog.pkla.erb"),
		require => File['30-site.d'],
	  }
	  }
 }