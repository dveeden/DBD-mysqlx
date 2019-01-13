use ExtUtils::MakeMaker;
use DBI::DBD;
use Devel::CheckLib;
use strict;
use warnings;

my $dbi_arch_dir = dbd_dbi_arch_dir();
my %opts = (
        'NAME'         => 'DBD::mysqlx',
        'VERSION_FROM' => 'lib/DBD/mysqlx.pm',
        'dist'         => { 'SUFFIX'   => '.gz',
                            'COMPRESS' => 'gzip -9f' },
        'realclean'    => { FILES => '*.xsi' },
        'PREREQ_PM'    => { 'DBI' => 1.642 },
        'OBJECT'       => '$(O_FILES)',
        'INC'          => "-I$dbi_arch_dir -I/usr/include/mysql-cppconn-8 -std=gnu99",
        'LIBS'         => '-lmysqlcppconn8',
        'CONFIGURE_REQUIRES' => {
            'DBI' => '1.642',
            'Devel::CheckLib' => '1.09',
            'ExtUtils::MakeMaker' => 0,
        },
);

assert_lib(
  LIBS => '-lmysqlcppconn8', # MySQL Connector/C++ 8.x
);

WriteMakefile(%opts);

package MY;
sub postamble { return DBI::DBD::dbd_postamble(@_); }
