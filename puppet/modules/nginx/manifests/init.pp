class nginx {
  package { 'nginx':
    ensure => installed,
  }
  # Disable default nginx site
  file { '/etc/nginx/sites-enabled/default':
    ensure => absent,
    before => Service[nginx]
  }
  file { "/etc/nginx/nginx.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("nginx/nginx.conf.tpl"),
    require => Package[nginx],
    notify  => Service[nginx],
  }
  service { 'nginx':
    ensure => running,
    require => Package[ 'nginx' ]
  }
}

define nginx::redirectssl( $sitename, $servername,  $redirecthost = '$host' ) {
  file { "/etc/nginx/sites-enabled/${sitename}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("nginx/redirect-ssl.tpl"),
    require => Package[nginx],
    notify  => Service[nginx],
  }
}
define nginx::proxy( $sitename, $servername, $staticfiles, $proxypass ) {
  file { "/etc/nginx/sites-enabled/${sitename}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("nginx/gunicorn.tpl"),
    require => Package[nginx],
    notify  => Service[nginx],
  }
}
define nginx::gunicornssl( $sitename, $servername, $appport, $sslcert, $sslcertkey, $staticfiles ) {
  file { "/etc/nginx/sites-enabled/${sitename}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("nginx/gunicorn-ssl.tpl"),
    require => Package[nginx],
    notify  => Service[nginx],
  }
}
define nginx::uwsgi( $appname, $appport, $servername ) {
  file { "/etc/nginx/sites-enabled/${appname}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("nginx/uwsgi.tpl"),
    require => Package[nginx],
    notify  => Service[nginx],
  }
}
