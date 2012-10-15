file { '/tmp/testfile':
  ensure  => present,
  mode    => '0664',
  content => "This is a test.\n",
}
