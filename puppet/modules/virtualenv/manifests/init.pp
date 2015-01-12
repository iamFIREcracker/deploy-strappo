class virtualenv {
  package { ['python-dev', 'python-virtualenv']:
    ensure => 'installed',
  }
}

define virtualenv::sync( $venvdir, $wd, $requirements ) {
  exec { "create $venvdir":
    command => "virtualenv $venvdir",
    unless => "ls $venvdir",
    user => $user,
    require => Package[ "python-virtualenv" ]
  }
  exec { "update $venvdir":
    cwd => $wd,
    command => "$venvdir/bin/pip install -r $requirements",
    user => $user,
    require => Exec[ "create $venvdir" ]
  }
}

define virtualenv::install( $venvdir, $package ) {
  exec { "install $venvdir/$package":
    command => "$venvdir/bin/pip install $package",
    user => $user,
    require => Exec[ "create $venvdir" ]
  }
}
