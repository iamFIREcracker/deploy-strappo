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

define supervisor::gunicorn( $appname, $user ) {
  supervisorctl {"supervisorctl-$appname":
    appname => $appname
  }
  file { "/etc/supervisor/conf.d/${appname}.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("supervisor/gunicorn.tpl"),
    require => Package[supervisor],
    notify  => Supervisorctl["supervisorctl-$appname"]
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

define supervisor::celery( $appname, $user ) {
  supervisorctl {"supervisorctl-$appname-celery":
    appname => "$appname-celery"
  }
  file { "/etc/supervisor/conf.d/${appname}-celery.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("supervisor/celery.tpl"),
    require => Package[supervisor],
    notify  => Supervisorctl["supervisorctl-$appname-celery"]
  }
}

define supervisor::celerybeat( $appname, $user ) {
  supervisorctl {"supervisorctl-$appname-celerybeat":
    appname => "$appname-celerybeat"
  }
  file { "/etc/supervisor/conf.d/${appname}-celerybeat.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("supervisor/celerybeat.tpl"),
    require => Package[supervisor],
    notify  => Supervisorctl["supervisorctl-$appname-celerybeat"]
  }
}
