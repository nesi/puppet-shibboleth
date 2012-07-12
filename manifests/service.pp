# Tuakiri Shibboleth Service Provider Manifest
# Based on the Tuakiri procedures for setting up a
# Shibboleth Service Provider
# Should work for other Shibboleth Federations

# NOTE: This manifest does NOT create the shibboleth back channel
# certificate (/etc/shibboleth/sp-cert.pem) and key (/etc/shibboleth/sp-key.pem)
# It should create these on the puppet server in the private file
# store and deploy them... or something cleverer.

class shibboleth::service(
	$metadata_cert_URL,
	$metadata_provider_URL 	= false,
	$httpd 					= 'apache2',
	$sp_domainname			= $fqdn,
	$handler_ssl			= true,
	$discovery_URL 			= false,
	$idp_URL				= false,
	$contact_email,
	$attribute_map_URL		= false,
	$support_ECP			= false
){

	# Jump to Ruby to get extract the file names
	$metadata_cert_file 	= inline_template("<%= metadata_cert_URL.split('/').last  %>")
	$metadata_cert_path 	= "/etc/shibboleth/${metadata_cert_file}"
	
	$metadata_provider_file = $metadata_provider_URL ? {
		false	=> undef,
		default => inline_template("<%= metadata_provider_URL.split('/').last  %>"),
	}

	$attribute_map_file 		= $attribute_map_URL ? {
		false	=> undef,
		default	=> inline_template("<%= attribute_map_URL.split('/').last %>")
	}
	$attribute_map_path			= "/etc/shibboleth/${attribute_map_file}"

	if $discovery_URL and $idp_URL {
		err("Shibboleth Service Provider must have either discovery_URL or idp_URL set, not both.")
	} elsif !$discovery_URL and !$idp_URL {
		err("Shibboleth Service Provider must have either discovery_URL or idp_URL set, not neither.")
	} else {
		case $operatingsystem {
			Ubuntu:{
				class{'shibboleth::service::install':
					metadata_cert_URL 		=> $metadata_cert_URL,
					metadata_cert_file		=> $metadata_cert_file,
					metadata_cert_path		=> $metadata_cert_path,
					metadata_provider_URL	=> $metadata_provider_URL,
					metadata_provider_file	=> $metadata_provider_file,
					httpd					=> $httpd,
					sp_domainname 			=> $sp_domainname,
					handler_ssl				=> $handler_ssl,
					discovery_URL			=> $discovery_URL,
					idp_URL					=> $idp_URL,
					contact_email 			=> $contact_email,
					attribute_map_URL 		=> $attribute_map_URL,
					attribute_map_path		=> $attribute_map_path,
					support_ECP 			=> $support_ECP,
				}
			}
			default:{
				warning("Shibboleth Service Provider not configured for ${operatingsystem} on ${fqdn}")
			}
		}
	}	
}
