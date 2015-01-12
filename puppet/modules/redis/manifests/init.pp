class redis {
  package { 'redis-server':
    ensure => 'installed',
  }
  service { 'redis-server':
    ensure => running,
    require => Package['redis-server']
  }
}

define redis::conf( $address, $port ) {
  file { "/etc/redis/redis.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '644',
    content => template("redis/redis.conf.tpl"),
    require => Package['redis-server'],
    notify  => Service['redis-server'],
  }
}
