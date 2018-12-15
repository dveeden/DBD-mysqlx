use strict;
use warnings;
use DBI;
use DBD::mysqlx;
use Test::More tests => 1;

my $dsn = "DBI:mysqlx:";
my $dbh = DBI->connect($dsn, "msandbox", "msandbox");
ok $dbh->do("DO 1");
$dbh->disconnect();
