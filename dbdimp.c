/*
 *  DBD::mysqlx - DBI X Protocol driver for the MySQL database
 *
 *  Copyright (c) 2018 Daniël van Eeden
 *
 *  You may distribute this under the terms of either the GNU General Public
 *  License or the Artistic License, as specified in the Perl README file.
 */

#include "dbdimp.h"

DBISTATE_DECLARE;

static void dbd_drv_error(SV *h, int rc, const char *what) {
  D_imp_xxh(h);

  DBIh_SET_ERR_CHAR(h, imp_xxh, Nullch, rc, what, Nullch, Nullch);

  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh), "dbd_drv_error\n");
}

void dbd_init(dbistate_t *dbistate) {
  DBISTATE_INIT; // Initialize the DBI macros
}

int dbd_db_login6(SV *dbh, imp_dbh_t *imp_dbh, char *dbname, char *uid,
                  char *pwd, SV *attribs) {
  int port = 33060;
  int errcode;
  char errstr[255];

  dTHX;
  D_imp_xxh(dbh);

  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh), "port=%d, user=%s, password=%s\n", port,
                  uid, pwd);

  imp_dbh->sess =
      mysqlx_get_session(NULL, port, uid, pwd, NULL, errstr, &errcode);

  if (!imp_dbh->sess) {
    dbd_drv_error(dbh, errcode, errstr);
    return 0;
  } else {
    DBIc_IMPSET_on(imp_dbh); // request call to destroy
    DBIc_ACTIVE_on(imp_dbh); // request call to disconnect
  }

  return 1;
}

int dbd_db_STORE_attrib(SV *dbh, imp_dbh_t *imp_dbh, SV *keysv, SV *valuesv) {
  return TRUE;
}

SV *dbd_db_FETCH_attrib(SV *dbh, imp_dbh_t *imp_dbh, SV *keysv) {
  return &PL_sv_yes;
}

int dbd_db_commit(SV *dbh, imp_dbh_t *imp_dbh) {
  D_imp_xxh(dbh);
  int result = mysqlx_transaction_commit(imp_dbh->sess);
  if ((result != RESULT_OK) && (DBIc_TRACE_LEVEL(imp_xxh) >= 2)) {
    PerlIO_printf(DBIc_LOGPIO(imp_xxh), "DBD::mysqlx dbd_db_commit err: %s\n",
                  mysqlx_error_message(imp_dbh->sess));
    return 1;
  } else {
    return 0;
  }
}

int dbd_db_rollback(SV *dbh, imp_dbh_t *imp_dbh) {
  D_imp_xxh(dbh);
  int result = mysqlx_transaction_rollback(imp_dbh->sess);
  if ((result != RESULT_OK) && (DBIc_TRACE_LEVEL(imp_xxh) >= 2)) {
    PerlIO_printf(DBIc_LOGPIO(imp_xxh), "DBD::mysqlx dbd_db_rollback err: %s\n",
                  mysqlx_error_message(imp_dbh->sess));
    return 1;
  } else {
    return 0;
  }
}

void dbd_db_destroy(SV *dbh, imp_dbh_t *imp_dbh) { return; }

int dbd_db_disconnect(SV *dbh, imp_dbh_t *imp_dbh) {
  if (imp_dbh->sess)
    mysqlx_session_close(imp_dbh->sess);

  DBIc_IMPSET_off(imp_dbh);

  return 1;
}

int dbd_st_STORE_attrib(SV *sth, imp_sth_t *imp_sth, SV *keysv, SV *valuesv) {
  return 0;
}

SV *dbd_st_FETCH_attrib(SV *sth, imp_sth_t *imp_sth, SV *keysv) {
  D_imp_xxh(sth);
  STRLEN(kl);
  char *key = SvPV(keysv, kl);
  int numFields = DBIc_NUM_FIELDS(imp_sth);

  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh), "dbd_st_FETCH_attrib %s\n", key);

  AV *av = newAV();
  for (int i = 0; i < numFields; i++) {
    SV *sv = &PL_sv_undef;

    switch (*key) {
    case 'N':
      if (strEQ(key, "NAME")) {
        const char *colname = mysqlx_column_get_name(imp_sth->result, i);
        sv = newSVpvn(colname, strlen(colname));
      }
      break;
    }
    av_push(av, sv);
  }

  if (av == Nullav)
    return &PL_sv_undef;

  return sv_2mortal(newRV_inc((SV *)av));
}

AV *dbd_st_fetch _((SV * sth, imp_sth_t *imp_sth)) {
  mysqlx_row_t *row;
  AV *av;
  int numFields = DBIc_NUM_FIELDS(imp_sth);
  long int intres;
  long unsigned int uintres;
  size_t buf_len = 1024;
  char buf[1024];
  char buf2[1024];
  size_t buf2_len = 1024;
  int precision;
  unsigned char dbuf[1024];
  size_t dbuf_len = 1024;
  bool is_negative;
  int64_t datetime[7] = {0};
  int offset;
  int part = 0;

  D_imp_xxh(sth);

  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh),
                  "DBD::mysqlx dbd_st_fetch with %d fields\n", numFields);

  if (!((row = mysqlx_row_fetch_one(imp_sth->result)))) {
    DBIc_ACTIVE_off(imp_sth);
    return Nullav;
  }

  // Docs for X Protocol data types:
  // https://dev.mysql.com/doc/internals/en/x-protocol-messages-messages.html
  // https://github.com/mysql/mysql-server/blob/8.0/plugin/x/protocol/mysqlx_resultset.proto

  av = DBIc_DBISTATE(imp_sth)->get_fbav(imp_sth);
  for (int i = 0; i < numFields; i++) {
    unsigned int coltype;
    coltype = mysqlx_column_get_type(imp_sth->result, i);
    if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
      PerlIO_printf(DBIc_LOGPIO(imp_xxh),
                    "DBD::mysqlx dbd_st_fetch column type for column %d: %u\n",
                    i, coltype);

    switch (coltype) {
    case MYSQLX_TYPE_SINT:
      mysqlx_get_sint(row, i, &intres);
      if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
        PerlIO_printf(DBIc_LOGPIO(imp_xxh),
                      "DBD::mysqlx dbd_st_fetch ROW[%d] = %ld\n", i, intres);
      sv_setiv(AvARRAY(av)[i], intres);
      break;
    case MYSQLX_TYPE_UINT:
      mysqlx_get_uint(row, i, &uintres);
      if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
        PerlIO_printf(DBIc_LOGPIO(imp_xxh),
                      "DBD::mysqlx dbd_st_fetch ROW[%d] = %ld\n", i, uintres);
      sv_setuv(AvARRAY(av)[i], uintres);
      break;
    case MYSQLX_TYPE_DOUBLE:
      // mysqlx_get_double()
      // sv_setnv()
    case MYSQLX_TYPE_FLOAT:
      // mysqlx_get_float()
      croak("Unsupported column type");
      break;
    case MYSQLX_TYPE_BYTES:
      buf_len = 1024;
      switch (mysqlx_get_bytes(row, i, 0, buf, &buf_len)) {
      case RESULT_NULL:
        SvOK_off(AvARRAY(av)[i]);
        break;
      case RESULT_ERROR:
        croak("Error fetching bytes");
        break;
      case RESULT_MORE_DATA: // TODO: Handle properly
      default:
        sv_setpvn(AvARRAY(av)[i], buf, buf_len);
      }
      break;
    case MYSQLX_TYPE_TIME:
      dbuf_len = 1024;
      switch (mysqlx_get_bytes(row, i, 0, dbuf, &dbuf_len)) {
      case RESULT_NULL:
        SvOK_off(AvARRAY(av)[i]);
        break;
      case RESULT_ERROR:
        croak("Error fetching bool");
        break;
      case RESULT_MORE_DATA: // TODO: Handle properly
      default:
        part = 0;
        offset = 0;
        if (dbuf[0] == 0x00)
          is_negative = false;
        else
          is_negative = true;
        memset(datetime, 0, sizeof(datetime));
        for (int j = 1; j < dbuf_len; j++) {
          if ((dbuf[j] & 128) == 128) {
            datetime[part] += (dbuf[j] & 127) << offset;
            offset = 7;
          } else {
            datetime[part] += (dbuf[j] & 127) << offset;
            offset = 0;
            part++;
          }
        }
        // TODO: Remove parts which are all zero
        buf_len = sprintf(buf,
                          is_negative ? "-%02ld:%02ld:%02ld.%06ld\n"
                                      : "%02ld:%02ld:%02ld.%06ld\n",
                          datetime[0], datetime[1], datetime[2], datetime[3]);
        sv_setpvn(AvARRAY(av)[i], buf, buf_len - 1);
      }
      break;
    case MYSQLX_TYPE_DATETIME:
      dbuf_len = 1024;
      switch (mysqlx_get_bytes(row, i, 0, dbuf, &dbuf_len)) {
      case RESULT_NULL:
        SvOK_off(AvARRAY(av)[i]);
        break;
      case RESULT_ERROR:
        croak("Error fetching bool");
        break;
      case RESULT_MORE_DATA: // TODO: Handle properly
      default:
        part = 0;
        offset = 0;
        memset(datetime, 0, sizeof(datetime));
        for (int j = 0; j < dbuf_len; j++) {
          if ((dbuf[j] & 128) == 128) {
            datetime[part] += (dbuf[j] & 127) << offset;
            offset = 7;
          } else {
            datetime[part] += (dbuf[j] & 127) << offset;
            offset = 0;
            part++;
          }
        }
        // TODO: Remove parts which are all zero
        buf_len = sprintf(buf, "%04ld-%02ld-%02ld %02ld:%02ld:%02ld.%06ld\n",
                          datetime[0], datetime[1], datetime[2], datetime[3],
                          datetime[4], datetime[5], datetime[6]);
        sv_setpvn(AvARRAY(av)[i], buf, buf_len - 1);
      }
      break;
    case MYSQLX_TYPE_SET:
    case MYSQLX_TYPE_ENUM:
    case MYSQLX_TYPE_BIT:
      croak("Unsupported column type");
      break;
    case MYSQLX_TYPE_DECIMAL: // Format: scale[1], Packed BCD, sign
      precision = mysqlx_column_get_precision(imp_sth->result, i);
      dbuf_len = 1024;
      switch (mysqlx_get_bytes(row, i, 1, dbuf, &dbuf_len)) {
      case RESULT_NULL:
        SvOK_off(AvARRAY(av)[i]);
        break;
      case RESULT_ERROR:
        croak("Error fetching decimal");
        break;
      case RESULT_MORE_DATA: // TODO: Handle properly
      default:
        buf_len = 0;
        is_negative = false;
        for (int j = 0; j < dbuf_len; j++) {
          unsigned int v1 = dbuf[j] >> 4;
          unsigned int v2 = dbuf[j] & 0x0F;
          switch (v1) {
          case 12:
            is_negative = false;
            goto bcd_done;
          case 13:
            is_negative = true;
            goto bcd_done;
          default:
            buf[buf_len++] = 48 + v1;
          }
          switch (v2) {
          case 12:
            is_negative = false;
            goto bcd_done;
          case 13:
            is_negative = true;
            goto bcd_done;
          default:
            buf[buf_len++] = 48 + v2;
          }
        }
      bcd_done:
        buf2_len = 0;
        for (int j = 0; j < buf_len; j++) {
          if ((j == 0) && is_negative)
            buf2[buf2_len++] = 0x2D; // -
          if ((buf_len - j) == precision)
            buf2[buf2_len++] = 0x2E; // .
          buf2[buf2_len++] = buf[j];
        }
        sv_setpvn(AvARRAY(av)[i], buf2, buf2_len);
      }
      break;
    case MYSQLX_TYPE_BOOL:
      buf_len = 1024;
      switch (mysqlx_get_bytes(row, i, 0, buf, &buf_len)) {
      case RESULT_NULL:
        SvOK_off(AvARRAY(av)[i]);
        break;
      case RESULT_ERROR:
        croak("Error fetching bool");
        break;
      case RESULT_MORE_DATA: // TODO: Handle properly
      default:
        if (buf[0] == 0x2)
          sv_setuv(AvARRAY(av)[i], 1);
        else
          sv_setuv(AvARRAY(av)[i], 0);
      }
      break;
    case MYSQLX_TYPE_JSON:
      croak("Unsupported column type");
      break;
    case MYSQLX_TYPE_STRING:
      buf_len = 1024;
      switch (mysqlx_get_bytes(row, i, 0, buf, &buf_len)) {
      case RESULT_NULL:
        SvOK_off(AvARRAY(av)[i]);
        break;
      case RESULT_ERROR:
        croak("Error fetching string");
        break;
      case RESULT_MORE_DATA: // TODO: Handle properly
      default:
        sv_setpvn(AvARRAY(av)[i], buf, buf_len - 1);
      }
      break;
    case MYSQLX_TYPE_GEOMETRY:
    case MYSQLX_TYPE_TIMESTAMP:
    case MYSQLX_TYPE_NULL:
    case MYSQLX_TYPE_EXPR:
      croak("Unsupported column type");
      break;
    default:
      croak("Unknown column type");
    }
  }

  return av;
}

int dbd_st_prepare(SV *sth, imp_sth_t *imp_sth, char *statement, SV *attribs) {
  D_imp_xxh(sth);
  D_imp_dbh_from_sth;
  int param_count;

  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh), "DBD::mysqlx dbd_st_prepare for %s\n",
                  statement);

  imp_sth->stmt = mysqlx_sql_new(imp_dbh->sess, statement, strlen(statement));

  // FIXME: use something similar to mysql_stmt_param_count()
  //        or actually handle comments. Maybe use count_params() from
  //        DBD::mysql
  for (param_count = 0; statement[param_count];
       statement[param_count] == '?' ? param_count++ : *statement++)
    ;
  DBIc_NUM_PARAMS(imp_sth) = param_count;

  DBIc_IMPSET_on(imp_sth);
  return 1;
}

int dbd_st_execute(SV *sth, imp_sth_t *imp_sth) {
  D_imp_xxh(sth);

  imp_sth->result = mysqlx_execute(imp_sth->stmt);
  if (!imp_sth->result) {
    if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
      PerlIO_printf(DBIc_LOGPIO(imp_xxh),
                    "DBD::mysqlx dbd_st_execute err: %s\n",
                    mysqlx_error_message(imp_sth->stmt));
    return -2;
  }

  DBIc_NUM_FIELDS(imp_sth) = mysqlx_column_get_count(imp_sth->result);
  DBIc_ACTIVE_on(imp_sth);

  uint64_t affected = mysqlx_get_affected_count(imp_sth->result);
  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh),
                  "DBD::mysqlx dbd_st_execute affected: %ld\n", affected);

  if (affected > INT_MAX) {
    return -1;
  } else {
    return (int)affected;
  }
}

int dbd_st_blob_read(SV *sth, imp_sth_t *imp_sth, int field, long offset,
                     long len, SV *destrv, long destoffset) {
  return 0;
}

int dbd_bind_ph(SV *sth, imp_sth_t *imp_sth, SV *param, SV *value, IV sql_type,
                SV *attribs, int is_inout, IV maxlen) {
  int param_num = SvIV(param);
  int result;

  D_imp_xxh(sth);

  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh),
                  "DBD::mysqlx dbd_bind_ph num=%d value=%s sql_type=%" IVdf
                  "\n",
                  param_num, neatsvpv(value, 0), sql_type);

  // TODO: switch(sql_type)
  // TODO: Handle other types than uint
  // TODO: The docs for mysqlx_stmt_bind() say all binds are reset on each call
  //       Should we call it only once? Move it to dbd_st_execute() ?
  result = mysqlx_stmt_bind(imp_sth->stmt, PARAM_UINT(SvUV(value)), PARAM_END);

  if (DBIc_TRACE_LEVEL(imp_xxh) >= 2)
    PerlIO_printf(DBIc_LOGPIO(imp_xxh), "DBD::mysqlx dbd_bind_ph result=%d\n",
                  result);
  if (result == RESULT_OK)
    return 1;

  return 0;
}

int dbd_st_finish3(SV *sth, imp_sth_t *imp_sth, int from_destroy) {
  if (DBIc_ACTIVE(imp_sth)) {
    mysqlx_result_free(imp_sth->result);
    imp_sth->result = NULL;
    DBIc_ACTIVE_off(imp_sth);
  }
  return 1;
}

void dbd_st_destroy(SV *sth, imp_sth_t *imp_sth) {
  DBIc_IMPSET_off(imp_sth); /* let DBI know we've done it   */
}
