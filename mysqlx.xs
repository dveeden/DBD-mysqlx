/*
 *  DBD::mysqlx - DBI X Protocol driver for the MySQL database
 *
 *  Copyright (c) 2018 Daniël van Eeden
 *
 *  You may distribute this under the terms of either the GNU General Public
 *  License or the Artistic License, as specified in the Perl README file.
 */

#include "mysqlx.h"
 
DBISTATE_DECLARE;

MODULE = DBD::mysqlx PACKAGE = DBD::mysqlx
 
INCLUDE: mysqlx.xsi
