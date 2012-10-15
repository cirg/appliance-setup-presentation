user { 'someuser':
  comment    => 'Some user',
  shell      => '/bin/bash',
  groups     => ['adm'],
  managehome => true,
}
