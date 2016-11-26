--- php-7.0.13/ext/spl/config.m4.orig	2016-11-08 16:07:54.000000000 +0100
+++ php-7.0.13/ext/spl/config.m4	2016-11-26 18:25:19.000000000 +0100
@@ -2,6 +2,6 @@
 dnl config.m4 for extension SPL
 
   AC_DEFINE(HAVE_SPL, 1, [Whether you want SPL (Standard PHP Library) support]) 
-  PHP_NEW_EXTENSION(spl, php_spl.c spl_functions.c spl_engine.c spl_iterators.c spl_array.c spl_directory.c spl_exceptions.c spl_observer.c spl_dllist.c spl_heap.c spl_fixedarray.c, no,, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1)
+  PHP_NEW_EXTENSION(spl, php_spl.c spl_functions.c spl_engine.c spl_iterators.c spl_array.c spl_directory.c spl_exceptions.c spl_observer.c spl_dllist.c spl_heap.c spl_fixedarray.c, no,, -DZEND_ENABLE_STATIC_TSRMLS_CACHE=1 -D_XPG4_2)
   PHP_INSTALL_HEADERS([ext/spl], [php_spl.h spl_array.h spl_directory.h spl_engine.h spl_exceptions.h spl_functions.h spl_iterators.h spl_observer.h spl_dllist.h spl_heap.h spl_fixedarray.h])
   PHP_ADD_EXTENSION_DEP(spl, pcre, true)
