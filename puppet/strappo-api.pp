include base
include mercurial
include virtualenv
include supervisor


Exec {
  path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin", ],
}

file {$workdir:
  ensure => 'directory',
  owner => $user,
  group => $user,
  require => File['/srv/www']
} 
mercurial::sync {"hg-sync":
  url => $repo_url,
  branch => $repo_branch,
  wd => $workdir,
  user => $user,
  require => File[ $workdir ]
}
virtualenv::sync {"venv-sync":
  venvdir => $venvdir,
  wd => $workdir,
  requirements => "$workdir/requirements.txt",
  require => Exec[ "switch $repo_url@$repo_branch" ]
}
file {"$workdir/local_config.py":
  ensure  => present,
  owner => $user,
  group => $user,
  mode => "664",
  content => template("deploy/${localconfig}"),
  require =>Virtualenv::Sync[ 'venv-sync' ]
}
file {"$workdir/local_celeryconfig.py":
  ensure  => present,
  owner => $user,
  group => $user,
  mode => "664",
  content => template("deploy/${localceleryconfig}"),
  require =>Virtualenv::Sync[ 'venv-sync' ]
}
exec {'alembic-migrate':
  cwd => $workdir,
  command => "$venvdir/bin/alembic upgrade head",
  user => $user,
  require =>Virtualenv::Sync[ 'venv-sync' ]
}
virtualenv::install {"venv-install gunicorn":
  venvdir => $venvdir,
  package => "gunicorn==19.1.1",
  require => [
    File[ "$workdir/local_config.py" ],
    File[ "$workdir/local_config.py" ]
  ]
}
virtualenv::install {"venv-install gevent":
  venvdir => $venvdir,
  package => "gevent==1.0.1",
  require => [
    File[ "$workdir/local_config.py" ],
    File[ "$workdir/local_config.py" ]
  ]
}
file {"$workdir/gunicorn.conf.py":
  ensure  => present,
  owner => $user,
  group => $user,
  mode => "664",
  content => template("deploy/$gunicornconf"),
  require => [
    Virtualenv::Install[ 'venv-install gunicorn' ],
    Virtualenv::Install[ 'venv-install gevent' ],
  ]
}
supervisor::gunicorn {"supervisor-gunicorn":
  appname => $appname,
  gunicorn => "$venvdir/bin/gunicorn",
  config => "$workdir/gunicorn.conf.py",
  use => "run_wsgi:app",
  wd => $workdir,
  user => $user,
  require => [
    Exec['alembic-migrate'],
    Virtualenv::Install[ 'venv-install gunicorn' ],
    Virtualenv::Install[ 'venv-install gevent' ],
  ]
}
supervisor::celery {'supervisor-celery':
  appname => "$appname-celery",
  celery => "$venvdir/bin/celery",
  app => "app",
  wd => $workdir,
  user => $user,
  require => [
    Exec['alembic-migrate'],
    Virtualenv::Install[ 'venv-install gunicorn' ],
    Virtualenv::Install[ 'venv-install gevent' ],
  ]
}
#supervisor::celerybeat {'supervisor-celerybeat':
  #appname => "$appname-celerybeat",
  #celery => "$venvdir/bin/celery",
  #app => "app",
  #wd => $workdir,
  #user => $user,
  #require => [
    #Exec['alembic-migrate'],
    #Virtualenv::Install[ 'venv-install gunicorn' ],
    #Virtualenv::Install[ 'venv-install gevent' ],
  #]
#}
