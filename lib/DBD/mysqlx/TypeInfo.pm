# The %type_info_all hash was automatically generated by
# DBI::DBD::Metadata::write_typeinfo_pm v2.014214.

package DBD::mysqlx::TypeInfo;

{
    require Exporter;
    require DynaLoader;
    @ISA = qw(Exporter DynaLoader);
    @EXPORT = qw(type_info_all);
    use DBI qw(:sql_types);

    $type_info_all = [
        {
            TYPE_NAME          =>  0,
            DATA_TYPE          =>  1,
            COLUMN_SIZE        =>  2,
            LITERAL_PREFIX     =>  3,
            LITERAL_SUFFIX     =>  4,
            CREATE_PARAMS      =>  5,
            NULLABLE           =>  6,
            CASE_SENSITIVE     =>  7,
            SEARCHABLE         =>  8,
            UNSIGNED_ATTRIBUTE =>  9,
            FIXED_PREC_SCALE   => 10,
            AUTO_UNIQUE_VALUE  => 11,
            LOCAL_TYPE_NAME    => 12,
            MINIMUM_SCALE      => 13,
            MAXIMUM_SCALE      => 14,
            SQL_DATA_TYPE      => 15,
            SQL_DATETIME_SUB   => 16,
            NUM_PREC_RADIX     => 17,
            INTERVAL_PRECISION => 18,
        },
        [ "bit",                              SQL_BIT,           1,         undef,undef,undef,            1,0,3,undef,0,undef,"bit(1)",                                     undef,undef,undef,undef,undef,undef, ],
        [ "tinyint",                          SQL_TINYINT,       3,         undef,undef,undef,            1,0,3,0,    0,0,    "tinyint",                                    undef,undef,undef,undef,10,   undef, ],
        [ "tinyint unsigned",                 SQL_TINYINT,       3,         undef,undef,undef,            1,0,3,1,    0,0,    "tinyint unsigned",                           undef,undef,undef,undef,10,   undef, ],
        [ "tinyint auto_increment",           SQL_TINYINT,       3,         undef,undef,undef,            0,0,3,0,    0,1,    "tinyint auto_increment",                     undef,undef,undef,undef,10,   undef, ],
        [ "tinyint unsigned auto_increment",  SQL_TINYINT,       3,         undef,undef,undef,            0,0,3,1,    0,1,    "tinyint unsigned auto_increment",            undef,undef,undef,undef,10,   undef, ],
        [ "bigint",                           SQL_BIGINT,        19,        undef,undef,undef,            1,0,3,0,    0,0,    "bigint",                                     undef,undef,undef,undef,10,   undef, ],
        [ "bigint unsigned",                  SQL_BIGINT,        20,        undef,undef,undef,            1,0,3,1,    0,0,    "bigint unsigned",                            undef,undef,undef,undef,10,   undef, ],
        [ "bigint auto_increment",            SQL_BIGINT,        19,        undef,undef,undef,            0,0,3,0,    0,1,    "bigint auto_increment",                      undef,undef,undef,undef,10,   undef, ],
        [ "bigint unsigned auto_increment",   SQL_BIGINT,        20,        undef,undef,undef,            0,0,3,1,    0,1,    "bigint unsigned auto_increment",             undef,undef,undef,undef,10,   undef, ],
        [ "long varbinary",                   SQL_LONGVARBINARY, 16777215,  "0x", undef,undef,            1,0,3,undef,0,undef,"mediumblob",                                 undef,undef,undef,undef,undef,undef, ],
        [ "blob",                             SQL_LONGVARBINARY, 65535,     "'",  "'",  undef,            1,0,3,undef,0,undef,"binary large object (0-65535)",              undef,undef,undef,undef,undef,undef, ],
        [ "longblob",                         SQL_LONGVARBINARY, 2147483647,"'",  "'",  undef,            1,0,3,undef,0,undef,"binary large object, use mediumblob instead",undef,undef,undef,undef,undef,undef, ],
        [ "tinyblob",                         SQL_LONGVARBINARY, 255,       "'",  "'",  undef,            1,0,3,undef,0,undef,"binary large object (0-255)",                undef,undef,undef,undef,undef,undef, ],
        [ "mediumblob",                       SQL_LONGVARBINARY, 16777215,  "'",  "'",  undef,            1,0,3,undef,0,undef,"binary large object",                        undef,undef,undef,undef,undef,undef, ],
        [ "varbinary",                        SQL_VARBINARY,     255,       "'",  "'",  "length",         1,0,3,undef,0,undef,"varbinary",                                  undef,undef,undef,undef,undef,undef, ],
        [ "binary",                           SQL_BINARY,        255,       "'",  "'",  "length",         1,0,3,undef,0,undef,"binary",                                     undef,undef,undef,undef,undef,undef, ],
        [ "long varchar",                     SQL_LONGVARCHAR,   16777215,  "'",  "'",  undef,            1,0,3,undef,0,undef,"mediumtext",                                 undef,undef,undef,undef,undef,undef, ],
        [ "text",                             SQL_LONGVARCHAR,   65535,     "'",  "'",  undef,            1,0,3,undef,0,undef,"text(0-65535)",                              undef,undef,undef,undef,undef,undef, ],
        [ "mediumtext",                       SQL_LONGVARCHAR,   16777215,  "'",  "'",  undef,            1,0,3,undef,0,undef,"mediumtext",                                 undef,undef,undef,undef,undef,undef, ],
        [ "longtext",                         SQL_LONGVARCHAR,   2147483647,"'",  "'",  undef,            1,0,3,undef,0,undef,"longtext",                                   undef,undef,undef,undef,undef,undef, ],
        [ "tinytext",                         SQL_LONGVARCHAR,   255,       "'",  "'",  undef,            1,0,3,undef,0,undef,"tinytext",                                   undef,undef,undef,undef,undef,undef, ],
        [ "char",                             SQL_CHAR,          255,       "'",  "'",  "length",         1,0,3,undef,0,undef,"char",                                       undef,undef,undef,undef,undef,undef, ],
        [ "numeric",                          SQL_NUMERIC,       19,        undef,undef,"precision,scale",1,0,3,0,    0,0,    "numeric",                                    0,    19,   undef,undef,10,   undef, ],
        [ "decimal",                          SQL_DECIMAL,       19,        undef,undef,"precision,scale",1,0,3,0,    0,0,    "decimal",                                    0,    19,   undef,undef,10,   undef, ],
        [ "integer",                          SQL_INTEGER,       10,        undef,undef,undef,            1,0,3,0,    0,0,    "integer",                                    undef,undef,undef,undef,10,   undef, ],
        [ "integer unsigned",                 SQL_INTEGER,       10,        undef,undef,undef,            1,0,3,1,    0,0,    "integer unsigned",                           undef,undef,undef,undef,10,   undef, ],
        [ "int",                              SQL_INTEGER,       10,        undef,undef,undef,            1,0,3,0,    0,0,    "integer",                                    undef,undef,undef,undef,10,   undef, ],
        [ "int unsigned",                     SQL_INTEGER,       10,        undef,undef,undef,            1,0,3,1,    0,0,    "integer unsigned",                           undef,undef,undef,undef,10,   undef, ],
        [ "mediumint",                        SQL_INTEGER,       7,         undef,undef,undef,            1,0,3,0,    0,0,    "Medium integer",                             undef,undef,undef,undef,10,   undef, ],
        [ "mediumint unsigned",               SQL_INTEGER,       8,         undef,undef,undef,            1,0,3,1,    0,0,    "Medium integer unsigned",                    undef,undef,undef,undef,10,   undef, ],
        [ "integer auto_increment",           SQL_INTEGER,       10,        undef,undef,undef,            0,0,3,0,    0,1,    "integer auto_increment",                     undef,undef,undef,undef,10,   undef, ],
        [ "integer unsigned auto_increment",  SQL_INTEGER,       10,        undef,undef,undef,            0,0,3,1,    0,1,    "integer unsigned auto_increment",            undef,undef,undef,undef,10,   undef, ],
        [ "int auto_increment",               SQL_INTEGER,       10,        undef,undef,undef,            0,0,3,0,    0,1,    "integer auto_increment",                     undef,undef,undef,undef,10,   undef, ],
        [ "int unsigned auto_increment",      SQL_INTEGER,       10,        undef,undef,undef,            0,0,3,1,    0,1,    "integer unsigned auto_increment",            undef,undef,undef,undef,10,   undef, ],
        [ "mediumint auto_increment",         SQL_INTEGER,       7,         undef,undef,undef,            0,0,3,0,    0,1,    "Medium integer auto_increment",              undef,undef,undef,undef,10,   undef, ],
        [ "mediumint unsigned auto_incremen ",SQL_INTEGER,       8,         undef,undef,undef,            0,0,3,1,    0,1,    "Medium integer unsigned auto_increment",     undef,undef,undef,undef,10,   undef, ],
        [ "smallint",                         SQL_SMALLINT,      5,         undef,undef,undef,            1,0,3,0,    0,0,    "smallint",                                   undef,undef,undef,undef,10,   undef, ],
        [ "smallint unsigned",                SQL_SMALLINT,      5,         undef,undef,undef,            1,0,3,1,    0,0,    "smallint unsigned",                          undef,undef,undef,undef,10,   undef, ],
        [ "smallint auto_increment",          SQL_SMALLINT,      5,         undef,undef,undef,            0,0,3,0,    0,1,    "smallint auto_increment",                    undef,undef,undef,undef,10,   undef, ],
        [ "smallint unsigned auto_increment", SQL_SMALLINT,      5,         undef,undef,undef,            0,0,3,1,    0,1,    "smallint unsigned auto_increment",           undef,undef,undef,undef,10,   undef, ],
        [ "double",                           SQL_FLOAT,         15,        undef,undef,undef,            1,0,3,0,    0,0,    "double",                                     0,    4,    undef,undef,10,   undef, ],
        [ "double auto_increment",            SQL_FLOAT,         15,        undef,undef,undef,            0,0,3,0,    0,1,    "double auto_increment",                      0,    4,    undef,undef,10,   undef, ],
        [ "float",                            SQL_REAL,          7,         undef,undef,undef,            1,0,0,0,    0,0,    "float",                                      0,    2,    undef,undef,10,   undef, ],
        [ "float auto_increment",             SQL_REAL,          7,         undef,undef,undef,            0,0,0,0,    0,1,    "float auto_increment",                       0,    2,    undef,undef,10,   undef, ],
        [ "double",                           SQL_DOUBLE,        15,        undef,undef,undef,            1,0,3,0,    0,0,    "double",                                     0,    4,    undef,undef,10,   undef, ],
        [ "double auto_increment",            SQL_DOUBLE,        15,        undef,undef,undef,            0,0,3,0,    0,1,    "double auto_increment",                      0,    4,    undef,undef,10,   undef, ],
        [ "date",                             SQL_TYPE_DATE,     10,        "'",  "'",  undef,            1,0,3,undef,0,undef,"date",                                       undef,undef,undef,91,   undef,undef, ],
        [ "time",                             SQL_TYPE_TIME,     8,         "'",  "'",  undef,            1,0,3,undef,0,undef,"time",                                       undef,undef,undef,92,   undef,undef, ],
        [ "year",                             SQL_SMALLINT,      4,         undef,undef,undef,            1,0,3,0,    0,0,    "year",                                       undef,undef,undef,undef,10,   undef, ],
        [ "datetime",                         SQL_TYPE_TIMESTAMP,21,        "'",  "'",  undef,            1,0,3,undef,0,undef,"datetime",                                   0,    0,    undef,93,   undef,undef, ],
        [ "timestamp",                        SQL_TYPE_TIMESTAMP,14,        "'",  "'",  undef,            0,0,3,undef,0,undef,"timestamp",                                  0,    0,    undef,93,   undef,undef, ],
        [ "varchar",                          SQL_VARCHAR,       255,       "'",  "'",  "length",         1,0,3,undef,0,undef,"varchar",                                    undef,undef,undef,undef,undef,undef, ],
    ];

    1;
}

__END__