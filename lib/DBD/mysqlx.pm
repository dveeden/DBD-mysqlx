package DBD::mysqlx;

our $VERSION = '0.001';
our @ISA     = 'DynaLoader';

__PACKAGE__->bootstrap($VERSION);

our $drh = undef;

sub driver {
    return $drh if $drh;      # already created - return same one
    my ($class, $attr) = @_;
 
    $class .= "::dr";

    # not a 'my' since we use it above to prevent multiple drivers
    $drh = DBI::_new_drh($class, {
            'Name'        => 'DBD::mysqlx',
            'Version'     => $VERSION,
            'Attribution' => 'DBD::mysqlx by Daniël van Eeden',
        })
        or return undef;
 
    return $drh;
}

sub CLONE {
  undef $drh;
}

package DBD::mysqlx::dr;

sub connect {
  my ($drh, $dbname, $user, $auth, $attr) = @_;

  my $dbh = DBI::_new_dbh($drh, {
    'Name' => $dbname,
  }) or return undef;

  DBD::mysqlx::db::_login($dbh, $dbname, $user, $auth, $attr)
    or return undef;

  $dbh;
}


package DBD::mysqlx::db;

sub prepare {
  my($dbh, $statement, @attribs) = @_;

  return undef if ! defined $statement;

  # Create a 'blank' statement handle:
  my $sth = DBI::_new_sth($dbh, {'Statement' => $statement});

  if (!DBD::mysqlx::st::_prepare($sth, $statement, @attribs)) {
    $sth = undef;
  }

  $sth;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

DBD::mysql - MySQL X Protocol driver for the Perl5 Database Interface (DBI)

=head1 COPYRIGHT

This module is Copyright (c) 2018 Daniël van Eeden
