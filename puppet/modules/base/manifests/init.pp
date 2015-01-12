class base {
  file {"/srv/www":
    ensure => 'directory',
    owner => $user,
    group => $user
  }

  file {"/srv/ssl":
    ensure => 'directory',
    owner => $user,
    group => $user
  }
}
