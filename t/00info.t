use strict;
use warnings;
use DBI;
use DBD::mysqlx;
use Test::More tests => 1;

my $test_dsn = defined($ENV{MYSQLX_TEST_DSN}) ? $ENV{MYSQLX_TEST_DSN} : "DBI:mysqlx:localhost/test";
my $test_user = defined($ENV{MYSQLX_TEST_USER}) ? $ENV{MYSQLX_TEST_USER} : "msandbox";
my $test_password = defined($ENV{MYSQLX_TEST_PASSWORD}) ? $ENV{MYSQLX_TEST_PASSWORD} : "msandbox";

my $dbh = DBI->connect($test_dsn, $test_user, $test_password);

# This is not a real test case, it's purpose is to show what we are testing against.
ok(1);
diag "\nDSN:     " . $test_dsn;
diag "Host:    " . $dbh->get_info(13);
diag "Version: " . $dbh->get_info(18);

$dbh->disconnect();
