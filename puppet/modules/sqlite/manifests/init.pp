class sqlite {
  package { 'sqlite3':
    ensure => 'installed',
  }
}

define sqlite::database( $path , $user ) {
  exec {"create $path":
    command => "mkdir -p $(dirname $path) && touch $path",
    unless => "ls $path",
    user => $user,
    require => Package['sqlite3']
  }
}
