--- php-7.0.13/ext/sockets/config.m4.orig	2016-11-08 16:08:09.000000000 +0100
+++ php-7.0.13/ext/sockets/config.m4	2016-11-26 18:09:06.000000000 +0100
@@ -56,6 +56,6 @@
     AC_DEFINE(HAVE_AI_V4MAPPED,1,[Whether you have AI_V4MAPPED])
   fi
 
-  PHP_NEW_EXTENSION([sockets], [sockets.c multicast.c conversions.c sockaddr_conv.c sendrecvmsg.c], [$ext_shared],, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
+  PHP_NEW_EXTENSION([sockets], [sockets.c multicast.c conversions.c sockaddr_conv.c sendrecvmsg.c], [$ext_shared],, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -D_XPG4_2)
   PHP_INSTALL_HEADERS([ext/sockets/], [php_sockets.h])
 fi
