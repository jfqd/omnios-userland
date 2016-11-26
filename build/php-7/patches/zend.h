--- php-7.0.13/Zend/zend.h.orig	2016-11-08 16:07:38.000000000 +0100
+++ php-7.0.13/Zend/zend.h	2016-11-17 21:57:10.000000000 +0100
@@ -28,6 +28,16 @@
 
 #define ZEND_MAX_RESERVED_RESOURCES	4
 
+typedef unsigned char   u_char;
+typedef unsigned short  u_short;
+typedef unsigned int    u_int;
+typedef unsigned long   u_long;
+
+#define INT64_MIN       (-9223372036854775807L-1)
+#elif defined(_LONGLONG_TYPE)
+#define INT64_MIN       (-9223372036854775807LL-1)
+#endif
+
 #include "zend_types.h"
 #include "zend_errors.h"
 #include "zend_alloc.h"
