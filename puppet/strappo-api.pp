include mercurial
include nginx
include redis
include python
include supervisor

Exec {
  path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin", ],
}

exec { "add_${user}_to_group_www-data":
  command => "usermod -a -G www-data ${user}",
  unless => "id ${user} | grep www-data",
  require => Package[nginx]
}

file {"/srv/ssl":
  ensure => 'directory',
  owner => 'www-data',
  group => 'www-data'
}


file {"/srv/ssl/$appname":
  ensure => 'directory',
  owner => 'www-data',
  group => 'www-data',
  require => File["/srv/ssl"]
}

file { "/srv/ssl/$appname/getstrappo.com.combined.crt":
  source => 'puppet:///modules/local/getstrappo.com.combined.crt',
  mode => 0400,
  owner => 'www-data',
  group => 'www-data',
  require => File["/srv/ssl/$appname"]
}

file { "/srv/ssl/$appname/getstrappo.com.key":
  source => 'puppet:///modules/local/getstrappo.com.key',
  mode => 0400,
  owner => 'www-data',
  group => 'www-data',
  require => File["/srv/ssl/$appname"]
}

nginx::gunicorn {'nginx':
  appname => $appname,
  appport => $appport,
  servername => $servername,
}

nginx::gunicornssl {'nginx-ssl':
  appname => $appname,
  appport => $appport,
  servername => $servername,
  sslcert => "/srv/ssl/$appname/getstrappo.com.combined.crt",
  sslcertkey => "/srv/ssl/$appname/getstrappo.com.key"
}

supervisor::gunicorn {'supervisor-gunicorn':
  appname => $appname,
  user => $user,
}

supervisor::celery {'supervisor-celery':
  appname => $appname,
  user => $user,
}

supervisor::celerybeat {'supervisor-celerybeat':
  appname => $appname,
  user => $user,
}
