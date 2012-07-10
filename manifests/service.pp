# Tuakiri Shibboleth Service Provider Manifest
# Based on the Tuakiri procedures for setting up a
# Shibboleth Service Provider
# Should work for other Shibboleth Federations

class shibboleth::service(

){
	case $operatingsystem {
		Ubuntu:{
			class{'shibboleth::service::install':

			}
		}
		default:{
			warning("Shibboleth Service Provider not configured for ${operatingsystem} on ${fqdn}")
		}
	}
}
