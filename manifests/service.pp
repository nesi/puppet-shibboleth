# Tuakiri Shibboleth Service Provider Manifest
# Based on the Tuakiri procedures for setting up a
# Shibboleth Service Provider
# Should work for other Shibboleth Federations

class shibboleth::service(
	$metadata_cert_URL,
	$metadata_provider_URL = false,
	$httpd 			= 'apache2',
	$sp_domainname	= $fqdn,
	$handler_ssl	= true,
	$discovery_URL 	= false,
	$idp_URL		= false,
	$contact_email
){
	if $discovery_URL and $idp_URL {
		err("Shibboleth Service Provider must have either discovery_URL or idp_URL set, not both.")
	} elsif !$discovery_URL and !$idp_URL {
		err("Shibboleth Service Provider must have either discovery_URL or idp_URL set, not neither.")
	} else {
		case $operatingsystem {
			Ubuntu:{
				class{'shibboleth::service::install':
					metadata_cert_URL 		=> $metadata_cert_URL,
					metadata_provider_URL	=> $metadata_provider_URL,
					httpd					=> $httpd,
					sp_domainname 			=> $sp_domainname,
					handler_ssl				=> $handler_ssl,
					discovery_URL			=> $discovery_URL,
					idp_URL					=> $idp_URL,
					contact_email 			=> $contact_email,
				}
			}
			default:{
				warning("Shibboleth Service Provider not configured for ${operatingsystem} on ${fqdn}")
			}
		}
	}	
}
