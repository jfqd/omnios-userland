--- php-7.0.13/ext/sqlite3/libsqlite/sqlite3.c.orig	2015-06-23 17:33:33.000000000 +0000
+++ php-7.0.13/ext/sqlite3/libsqlite/sqlite3.c
@@ -8408,7 +8408,7 @@ struct sqlite3_rtree_query_info {
 ** But _XOPEN_SOURCE define causes problems for Mac OS X, so omit
 ** it.
 */
-#if !defined(_XOPEN_SOURCE) && !defined(__DARWIN__) && !defined(__APPLE__)
+#if !defined(_XOPEN_SOURCE) && !defined(__DARWIN__) && !defined(__APPLE__) && !defined(__sun)
 #  define _XOPEN_SOURCE 600
 #endif
