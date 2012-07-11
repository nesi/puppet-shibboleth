# Tuakiri Shibboleth Service Provider Manifest
# Based on the Tuakiri procedures for setting up a
# Shibboleth Service Provider
# Should work for other Shibboleth Federations

class shibboleth::service(
	$metadatacert,
	$httpd 			= 'apache2',
	$sp_domainname	= $fqdn,
	$handler_ssl	= true
){
	case $operatingsystem {
		Ubuntu:{
			class{'shibboleth::service::install':
				metadatacert 	=> $metadatacert,
				httpd			=> $httpd,
				sp_domainname 	=> $sp_domainname,
				handler_ssl		=> $handler_ssl,
			}
		}
		default:{
			warning("Shibboleth Service Provider not configured for ${operatingsystem} on ${fqdn}")
		}
	}
}
