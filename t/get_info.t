use strict;
use warnings;
use DBI;
use DBD::mysqlx;
use Test::More tests => 7;

my $dsn = "DBI:mysqlx:localhost/test";
my $dbh = DBI->connect($dsn, "msandbox", "msandbox");

cmp_ok($dbh->get_info(2), "eq", "dbi:mysqlx:localhost", "SQL_DATA_SOURCE_NAME");

# TODO: Detect version to match against
cmp_ok($dbh->get_info(7), "eq", "00.03.0000", "SQL_DRIVER_VER");

cmp_ok($dbh->get_info(13), "eq", "localhost", "SQL_SERVER_NAME");
cmp_ok($dbh->get_info(16), "eq", "test", "SQL_DATABASE_NAME");

# TODO: Detect version to match against
cmp_ok($dbh->get_info(18), "eq", "8.0.13", "SQL_DBMS_VERSION");

cmp_ok($dbh->get_info(25), "eq", "N", "SQL_DATA_SOURCE_READ_ONLY");
cmp_ok($dbh->get_info(47), "eq", "msandbox", "SQL_USER_NAME");

$dbh->disconnect();
