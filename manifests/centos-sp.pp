# only for CentOS 
class shibboleth::centos-sp(
  $entityID,
  $discoveryURL,
  $supportContact,
  $metadataSources) {

    case $lsbmajdistrelease {
      5: { $repo = "CentOS_5" }
      6: { $repo = "CentOS_CentOS-6" }
    }

    yumrepo {"security-shibboleth":
      baseurl => "http://download.opensuse.org/repositories/security:/shibboleth/$repo/",
      gpgcheck => 1,
      enabled => 1,
      gpgkey => "http://download.opensuse.org/repositories/security:/shibboleth/$repo/repodata/repomd.xml.key"
    } 

    case $architecture {
      x86_64: { package {"shibboleth": name => "shibboleth.x86_64"}}
      default: { package {"shibboleth": name => "shibboleth"}}
    }

    Package["shibboleth"] { require => Yumrepo["security-shibboleth"], ensure => installed }

    file {"shibboleth2.xml":
      name => "/etc/shibboleth/shibboleth2.xml",
      owner => root,	
      group => root,
      mode => 644,
      content => template("shibboleth/shibboleth2.centos.xml.erb"),
      notify => Service["shibd"],
      require => Package["shibboleth"]
    }	     

    file {"attribute-map.xml":
      name => "/etc/shibboleth/attribute-map.xml",
      owner => root,	
      group => root,
      mode => 644,
      content => template("shibboleth/attribute-map.centos.xml.erb"),
      notify => Service["shibd"],
      require => Package["shibboleth"]
    }

    file{"metadata":
      name=>"/etc/shibboleth/metadata",
      ensure => directory,
      owner => root,
      group => root,
      recurse => true,
      ignore => ".svn",
      purge => false
    }

    file {"attribute-policy.xml":
      name => "/etc/shibboleth/attribute-policy.xml",
      owner => root,	
      group => root,
      mode => 644,
      content => template("shibboleth/attribute-policy.centos.xml.erb"),
      notify => Service["shibd"],
      require => Package["shibboleth"]
    }	     
 
    service {"shibd": ensure => running}

}
