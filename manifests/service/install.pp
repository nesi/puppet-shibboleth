# Installs Shibboleth Service Provider

# DO NOT CALL DIRECTLY
# Use:
#
# include shibboleth::service

class shibboleth::service::install(
	
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

			package{'libapache2-mod-shib2':
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
			package{'sibboleth':
				ensure => present,
				require => Yumrepo['shibboleth'],
			}
		}
	}

	
}