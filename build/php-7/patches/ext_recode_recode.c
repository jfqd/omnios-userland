--- php-7.0.5/ext/recode/recode.c.orig	2016-07-24 13:07:47.000000000 +0000
+++ php-7.0.5/ext/recode/recode.c
@@ -29,11 +29,8 @@

 #if HAVE_LIBRECODE

-/* For recode 3.5 */
-#if HAVE_BROKEN_RECODE
-extern char *program_name;
-char *program_name = "php";
-#endif
+extern const char *program_name;
+const char *program_name = "php";

 #ifdef HAVE_STDBOOL_H
 # include <stdbool.h>