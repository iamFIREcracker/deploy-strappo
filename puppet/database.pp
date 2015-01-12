include sqlite


Exec {
  path => [ "/usr/local/sbin", "/usr/local/bin", "/usr/sbin", "/usr/bin", "/sbin", "/bin", ],
}


sqlite::database{'sqlite create':
  path => $databasepath,
  user => $user
}
