include base
include nginx


Exec {
  path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin", ],
}

exec { "add_${user}_to_group_www-data":
  command => "usermod -a -G www-data ${user}",
  unless => "id ${user} | grep www-data",
  require => Package[nginx]
}
file { "/srv/ssl/$sslcert":
  source => "puppet:///modules/deploy/$sslcert",
  mode => 0400,
  owner => 'www-data',
  group => 'www-data',
  require => [
    File[ "/srv/ssl" ],
    Exec[ "add_${user}_to_group_www-data" ]
  ]
}
file { "/srv/ssl/$sslcertkey":
  source => "puppet:///modules/deploy/$sslcertkey",
  mode => 0400,
  owner => 'www-data',
  group => 'www-data',
  require => File[ "/srv/ssl" ]
}
nginx::redirectssl {"nginx-redirectssl getstrappoit":
  sitename => "getstrappoit",
  servername => $getstrappoit_servername,
  redirecthost => $getstrappo_servername
}
nginx::redirectssl {"nginx-redirectssl getstrappo":
  sitename => "getstrappo",
  servername => $getstrappo_servername
}
nginx::gunicornssl {"nginx-ssl getstrappo":
  sitename => "getstrappo-ssl",
  servername => $getstrappo_servername,
  appport => $getstrappo_appport,
  sslcert => "/srv/ssl/$sslcert",
  sslcertkey => "/srv/ssl/$sslcertkey",
  staticfiles => $getstrappo_staticfiles,
  require => [
    File[ "/srv/ssl/$sslcert" ],
    File[ "/srv/ssl/$sslcertkey" ]
  ]
}
nginx::gunicornssl {"nginx-ssl api":
  sitename => "strappo-api-ssl",
  servername => $api_servername,
  appport => $api_appport,
  sslcert => "/srv/ssl/$sslcert",
  sslcertkey => "/srv/ssl/$sslcertkey",
  staticfiles => $api_staticfiles,
  require => [
    File[ "/srv/ssl/$sslcert" ],
    File[ "/srv/ssl/$sslcertkey" ]
  ]
}
nginx::proxy {'nginx-proxy api':
  sitename => 'strappo-api',
  servername => $api_servername,
  staticfiles => $api_staticfiles,
  proxypass => "strappo-api-ssl",
  require => Nginx::Gunicornssl[ "nginx-ssl api" ]
}
nginx::redirectssl {"nginx-redirectssl analytics":
  sitename => "strappo-analytics",
  servername => $analytics_servername
}
nginx::gunicornssl {"nginx-ssl analytics":
  sitename => "strappo-analytics-ssl",
  servername => $analytics_servername,
  appport => $analytics_appport,
  sslcert => "/srv/ssl/$sslcert",
  sslcertkey => "/srv/ssl/$sslcertkey",
  staticfiles => $analytics_staticfiles,
  require => [
    File[ "/srv/ssl/$sslcert" ],
    File[ "/srv/ssl/$sslcertkey" ]
  ]
}
