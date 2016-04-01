--- php-7.0.5/ext/sockets/config.m4.orig	2016-04-01 16:49:35.000000000 +0200
+++ php-7.0.5/ext/sockets/config.m4	2016-04-01 16:50:06.000000000 +0200
@@ -56,6 +56,6 @@
     AC_DEFINE(HAVE_AI_V4MAPPED,1,[Whether you have AI_V4MAPPED])
   fi
 
-  PHP_NEW_EXTENSION([sockets], [sockets.c multicast.c conversions.c sockaddr_conv.c sendrecvmsg.c], [$ext_shared],, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
+  PHP_NEW_EXTENSION([sockets], [sockets.c multicast.c conversions.c sockaddr_conv.c sendrecvmsg.c], [$ext_shared],, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -D_XPG4_2)
   PHP_INSTALL_HEADERS([ext/sockets/], [php_sockets.h])
 fi
