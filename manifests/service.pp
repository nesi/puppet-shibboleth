# Tuakiri Shibboleth Service Provider Manifest
# Based on the Tuakiri procedures for setting up a
# Shibboleth Service Provider
# Should work for other Shibboleth Federations

class shibboleth::service(
	$metadatacert,
	$httpd 			= 'apache2'

){
	case $operatingsystem {
		Ubuntu:{
			class{'shibboleth::service::install':
				metadatacert 	=> $metadatacert,
				httpd			=> $httpd,
			}
		}
		default:{
			warning("Shibboleth Service Provider not configured for ${operatingsystem} on ${fqdn}")
		}
	}
}
