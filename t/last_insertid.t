use strict;
use warnings;
use DBI;
use DBD::mysqlx;
use Test::More tests => 7;

my $test_dsn = defined($ENV{MYSQLX_TEST_DSN}) ? $ENV{MYSQLX_TEST_DSN} : "DBI:mysqlx:localhost/test";
my $test_user = defined($ENV{MYSQLX_TEST_USER}) ? $ENV{MYSQLX_TEST_USER} : "msandbox";
my $test_password = defined($ENV{MYSQLX_TEST_PASSWORD}) ? $ENV{MYSQLX_TEST_PASSWORD} : "msandbox";

my $dbh = DBI->connect($test_dsn, $test_user, $test_password);

ok $dbh->do("CREATE TEMPORARY TABLE t1(id int auto_increment primary key)");
ok my $sth = $dbh->prepare("INSERT INTO t1() VALUES()");

ok $sth->execute();
is $sth->last_insert_id(undef, undef, undef, undef), 1;

ok $sth->execute();
is $sth->last_insert_id(undef, undef, undef, undef), 2;

ok $sth->finish();

$dbh->disconnect();
