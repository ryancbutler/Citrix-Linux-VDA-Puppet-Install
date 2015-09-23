class ctx_vda::set_hostname {

	class rhel {
#Edits hosts for name resolution
file { '/etc/hosts':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/hosts.erb"),
  }
  }
 
 }