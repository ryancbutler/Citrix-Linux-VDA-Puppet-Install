class ctx_vda {
#ASSIGN NODES TO THIS CLASS
  
  #only want to run against redhat
  if $osfamily == 'redhat' {
  include ctx_vda::set_hostname::rhel
  include ctx_vda::disable_networkproxy::rhel
  include ctx_vda::ctxvda_packages::rhel
  include ctx_vda::samba::rhel
  include ctx_vda::ctx_vda_install::rhel
  } 
  else {
	notify { "${module_name}_exception" : 
    message  => "OS ${osfamily} is not supported by module ${module_name}.",
    }
  }
  
  }
