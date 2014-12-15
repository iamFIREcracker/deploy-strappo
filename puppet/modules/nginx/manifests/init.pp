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
  }
}

define nginx::redirectssl( $appname, $appport, $servername ) {
  file { "/etc/nginx/sites-enabled/${appname}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("nginx/redirect-ssl.tpl"),
    require => Package[nginx],
    notify  => Service[nginx],
  }
}

define nginx::gunicorn( $appname, $appport, $servername ) {
  file { "/etc/nginx/sites-enabled/${appname}":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("nginx/gunicorn.tpl"),
    require => Package[nginx],
    notify  => Service[nginx],
  }
}

define nginx::gunicornssl( $appname, $appport, $servername,
                           $sslcert, $sslcertkey ) {
  file { "/etc/nginx/sites-enabled/${appname}-ssl":
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
