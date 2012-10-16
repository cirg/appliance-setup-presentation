file { '/tmp/testfile':
  ensure  => file,
  mode    => '0664',
  content => "This is a test.\n",
}
