# Installs Shibboleth Service Provider

# DO NOT CALL DIRECTLY
# Use:
#
# include shibboleth::service

class shibboleth::service::install(
	$metadata_cert_URL,
	$metadata_provider_URL,
	$httpd,
	$sp_domainname,
	$handler_ssl,
	$discovery_URL,
	$idp_URL,
	$contact_email
){

# Install packages
	case $operatingsystem{
		Ubuntu:{
			$libshibsp = $lsbmajdistrelease ?{
				'12'	=> 'libshibsp5',
				default => 'libshibsp4',
			}
			package{$libshibsp: ensure => present}
			package{'libshibsp-doc': ensure => present}

			$mod_shib = 'libapache2-mod-shib2'
			package{$mod_shib:
				ensure 	=> present,
			}
		}
		# Untested!
		CentOS:{
			yumrepo { "shibboleth":
			    descr => 'Shibboleth $releasever - $basearch',
			    baseurl => 'http://download.opensuse.org/repositories/security:/shibboleth/${releasever}/${basearch}',
			    enabled => 1,
			    failovermethod => "priority",
			    gpgcheck => 1,
			    gpgkey => "http://download.opensuse.org/repositories/security:/shibboleth/${releasever}/repodata/repomd.xml.key",
			}
			$mod_shib = 'shibboleth'
			package{$mod_shib:
				ensure => present,
				require => Yumrepo['shibboleth'],
			}
		}
	}

	# Jump to Ruby to get extract the file names
	$metadata_cert_file 	= inline_template("<%= metadata_cert_URL.split('/').last  %>")
	$metadata_cert_path 	= "/etc/shibboleth/${metadatacert_file}"
	
	$metadata_provider_file = $metadata_provider_URL ? {
		false	=> undef,
		default => inline_template("<%= metadata_provider_URL.split('/').last  %>"),
	}

	exec{'get_metadatacert':
		path	=> ['/usr/bin'],
		command => "wget ${metadata_cert_URL} -O ${metadata_cert_path}",
		creates => $metadata_cert_path,
		require => Package[$mod_shib],
		notify	=> Service[$httpd],
	}
	
	file{'shibboleth2.xml':
		ensure 	=> file,
		path 	=> '/etc/shibboleth/shibboleth2.xml',
		content => template('shibboleth/shibboleth2.xml.erb'),
		require	=> Package[$mod_shib],
		notify 	=> Service[$httpd],
	}
}