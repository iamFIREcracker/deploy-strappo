class mercurial {
  package { 'mercurial':
    ensure => 'installed',
  }
}

define mercurial::sync( $url, $branch, $wd, $user ) {
  exec { "clone $url":
    command => "hg clone $url $wd",
    unless => "ls $wd/.hg",
    user => $user,
    require => Package[mercurial]
  }

  exec { "update $url":
    cwd => $wd,
    command => "hg pull -u",
    user => $user,
    require => Exec["clone $url"]
  }

  exec { "switch $url@$branch":
    cwd => $wd,
    command => "hg update $branch",
    user => $user,
    require => Exec["update $url"]
  }
}
