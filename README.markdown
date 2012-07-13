# puppet-shibboleth
===================

A puppet module for managing Shibboleth Service Providers (SP). It will be expanded to include Identity Providers (IDp).

* http://shibboleth.net/

# To install into puppet

Clone into your puppet configuration in your `puppet/modules` directory:

 git clone git://github.com/nesi/puppet-shibboleth.git git

Or if you're managing your Puppet configuration with git, in your `puppet` directory:

		git submodule add git://github.com/nesi/puppet-shibboleth.git modules/git --init --recursive
		cd modules/shibboleth
		git checkout master
		git pull
		cd ../..
		git commit -m "added shibboleth submodule from https://github.com/nesi/puppet-shibboleth"

It might seem bit excessive, but it will make sure the submodule isn't headless...

# `shibboleth::service` Usage

**NOTE:** the URLs provided in the usage guide are examples only, check with your IDp or Federation administrator for the correct details.

## For a Service Provider (SP) using a single Identity Provider (IDp)

To install and configure  a SP to use a single IDp, add the following to a node definition :

		class{'shibboleth::service':
				metadata_cert_URL		=> 'http://idp.example.org/metadata/idp-metadata-cert.pem',
				httpd					=> 'apache2',
				idp_URL         		=> 'https://idp.example.org/',
				contact_email         	=> 'support@example.org',
		}

## For a Service Provider (SP) using a Federation Directory Service

To install and configure  a SP to use a Directory service provided by a Shibboleth Federation, add the following to a node definition :

		class{'shibboleth::service':
				metadata_cert_URL		=> 'http://directory.federation.org/metadata/federation-metadata-cert.pem',
				metadata_provider_URL 	=> 'https://directory.federation.org/metadata/federation-metadata-signed.xml',
				httpd					=> 'apache2',
				discovery_URL         	=> 'https://directory.federation.org/ds/DS',
				contact_email         	=> 'support@example.org',
				attribute_map_URL     	=> 'https://federation.org/download/attribute-map.xml',
		}

## Parameters

* *metadata_cert_URL* Required. A URL to download the metadata signing certificate from.
* *metadata_provider_URL* The source of the Federation metadata.
* *httpd* Required. The name of the `httpd` serveice to be restarted.
* *sp_domainname* The name of the Service Provider, defaults to `$fqdn`
* *handler_ssl* Enables the SSL handler, defaults to false.
* *discovery_URL* URL to the Federation discovery service
* *idp_URL*	URL to a single IDp 
* *contact_email* A contact email address, shown when things go wrong
* *attribute_map_URL* A map of the attributes provided by the IDp or the Federation
* *support_ECP* Supports system logins using the ECP protocols.

The parameters *discovery_URL* and *idp_URL* are exclusive, both can not be set at the same time. The module should throw an error. One of them is required.

# Credits
=========

Written by Aaron Hicks (hicksa@landcareresearch.co.nz) for the New Zealand eScience Infrastructure.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/"><img alt="Creative Commons Licence" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/">Creative Commons Attribution-ShareAlike 3.0 Unported License</a>