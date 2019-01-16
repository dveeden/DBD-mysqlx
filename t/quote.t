use strict;
use warnings;
use DBI;
use DBD::mysqlx;
use Test::More;

my $test_dsn = defined($ENV{MYSQLX_TEST_DSN}) ? $ENV{MYSQLX_TEST_DSN} : "DBI:mysqlx:localhost/test";
my $test_user = defined($ENV{MYSQLX_TEST_USER}) ? $ENV{MYSQLX_TEST_USER} : "msandbox";
my $test_password = defined($ENV{MYSQLX_TEST_PASSWORD}) ? $ENV{MYSQLX_TEST_PASSWORD} : "msandbox";

my $dbh = DBI->connect($test_dsn, $test_user, $test_password);

my @sqlmodes = (qw/ empty ANSI_QUOTES NO_BACKSLASH_ESCAPES/);
my @words = (qw/ foo foo'bar foo\bar /);
my @results_empty = (qw/ 'foo' 'foo\'bar' 'foo\\\\bar'/);
my @results_ansi = (qw/ 'foo' 'foo\'bar' 'foo\\\\bar'/);
my @results_no_backlslash = (qw/ 'foo' 'foo''bar' 'foo\\bar'/);
my @results = (\@results_empty, \@results_ansi, \@results_no_backlslash);

plan tests => (@sqlmodes * @words * 2 + 1);

while (my ($i, $sqlmode) = each @sqlmodes) {
  $dbh->do("SET sql_mode=?", undef,  $sqlmode eq "empty" ? "" : $sqlmode);
  for my $j (0..@words-1) {
    ok $dbh->quote($words[$j]);
    cmp_ok($dbh->quote($words[$j]), "eq", $results[$i][$j], "$sqlmode $words[$j]");
  }
}

ok $dbh->disconnect;
