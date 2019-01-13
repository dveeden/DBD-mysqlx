use strict;
use warnings;
use DBI;
use DBD::mysqlx;
use Test::More tests => 7;

my $test_dsn = defined($ENV{MYSQLX_TEST_DSN}) ? $ENV{MYSQLX_TEST_DSN} : "DBI:mysqlx:localhost/test";
my $test_user = defined($ENV{MYSQLX_TEST_USER}) ? $ENV{MYSQLX_TEST_USER} : "msandbox";
my $test_password = defined($ENV{MYSQLX_TEST_PASSWORD}) ? $ENV{MYSQLX_TEST_PASSWORD} : "msandbox";

my $dbh = DBI->connect($test_dsn, $test_user, $test_password);

my ($expected_dsn) = split(/\//, lc $test_dsn);
cmp_ok($dbh->get_info(2), "eq", $expected_dsn, "SQL_DATA_SOURCE_NAME");

my $expected_sql_driver_ver = sprintf '%02d.%02d.0000', split (/\./, $DBD::mysqlx::VERSION);
diag $expected_sql_driver_ver;
cmp_ok($dbh->get_info(7), "eq", $expected_sql_driver_ver, "SQL_DRIVER_VER");

my $expected_server_name = $1 if $expected_dsn =~ /dbi:mysqlx:(.+)/;
cmp_ok($dbh->get_info(13), "eq", $expected_server_name, "SQL_SERVER_NAME");
cmp_ok($dbh->get_info(16), "eq", "test", "SQL_DATABASE_NAME");

my $expected_dbms_version = $dbh->selectall_arrayref('SELECT @@version')->[0][0];
cmp_ok($dbh->get_info(18), "eq", $expected_dbms_version, "SQL_DBMS_VERSION");

cmp_ok($dbh->get_info(25), "eq", "N", "SQL_DATA_SOURCE_READ_ONLY");
cmp_ok($dbh->get_info(47), "eq", "msandbox", "SQL_USER_NAME");

$dbh->disconnect();
