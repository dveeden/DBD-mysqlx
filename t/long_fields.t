use strict;
use warnings;
use DBI;
use DBD::mysqlx;
use Test::More tests => 1;
use utf8;

my $test_dsn = defined($ENV{MYSQLX_TEST_DSN}) ? $ENV{MYSQLX_TEST_DSN} : "DBI:mysqlx:localhost/test";
my $test_user = defined($ENV{MYSQLX_TEST_USER}) ? $ENV{MYSQLX_TEST_USER} : "msandbox";
my $test_password = defined($ENV{MYSQLX_TEST_PASSWORD}) ? $ENV{MYSQLX_TEST_PASSWORD} : "msandbox";

my $dbh = DBI->connect($test_dsn, $test_user, $test_password);

# The value here should be > DBD_MYSQLX_FETCH_BUF_LEN
cmp_ok(length($dbh->selectall_arrayref("SELECT REPEAT('x', 2048)")->[0][0]), "==", 2048, "repeat_x_2048");

$dbh->disconnect();
