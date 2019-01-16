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

MODULE = DBD::mysqlx PACKAGE = DBD::mysqlx::db

SV*
ping(dbh)
  SV* dbh;
  PROTOTYPE: $
  CODE:
    int retval = 0;
    D_imp_dbh(dbh);

    mysqlx_result_t *result =
      mysqlx_sql(imp_dbh->sess, "/* DBD::mysqlx ping */", MYSQLX_NULL_TERMINATED);
    if (result != NULL) retval=1;
    RETVAL = boolSV(retval);
  OUTPUT:
    RETVAL

void
quote(dbh, str, type=NULL)
  SV* dbh
  SV* str
  SV* type
  PROTOTYPE: $$;$
  CODE:
{
    STRLEN from_len;
    SV *result;
    char *result_ptr;

    char *from = SvPV(str, from_len);

    result = newSV(from_len*2+3);
    result_ptr = SvPVX(result);
    *result_ptr++ = '\'';

    char *from_ptr = from;
    for (int i = 0; i < from_len; i++) {
      switch (*from_ptr) {
      case '"':
      case '\\':
      case '\'':
        *result_ptr++ = '\\';
      default:
        *result_ptr++ = *from_ptr;
        break;
      }
      *from_ptr++;
    }
    *result_ptr++ = '\'';
    SvPOK_on(result);
    SvCUR_set(result, result_ptr - SvPVX(result));

    ST(0) = sv_2mortal(result);
    XSRETURN(1);
}
