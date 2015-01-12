class supervisor {
  package { 'supervisor':
    ensure => installed,
  }
  service { 'supervisor':
    ensure => running,
  }
}

define supervisorctl( $appname ) {
  exec { "supervisorctl reload $appname":
    refreshonly => false,
    command => "supervisorctl reload $appname",
    logoutput => on_failure
  }
}

define supervisor::gunicorn( $appname, $gunicorn, $config, $use, $wd, $user ) {
  file { "/etc/supervisor/conf.d/${appname}.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("supervisor/gunicorn.tpl"),
    require => Package[supervisor],
  }
  supervisorctl {"supervisorctl-$appname":
    appname => $appname,
    require => File[ "/etc/supervisor/conf.d/${appname}.conf" ]
  }
}

define supervisor::uwsgi( $appname, $user ) {
  supervisorctl {"supervisorctl-$appname":
    appname => $appname
  }
  file { "/etc/supervisor/conf.d/${appname}.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("supervisor/uwsgi.tpl"),
    require => Package[supervisor],
    notify  => Supervisorctl["supervisorctl-$appname"]
  }
}

define supervisor::celery( $appname, $celery, $app, $wd, $user ) {
  file { "/etc/supervisor/conf.d/${appname}.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("supervisor/celery.tpl"),
    require => Package[supervisor]
  }
  supervisorctl {"supervisorctl-$appname":
    appname => $appname,
    require => File[ "/etc/supervisor/conf.d/${appname}.conf" ]
  }
}

define supervisor::celerybeat( $appname, $celery, $app, $wd, $user ) {
  file { "/etc/supervisor/conf.d/${appname}.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("supervisor/celerybeat.tpl"),
    require => Package[supervisor]
  }
  supervisorctl {"supervisorctl-$appname":
    appname => $appname,
    require => File[ "/etc/supervisor/conf.d/${appname}.conf" ]
  }
}
