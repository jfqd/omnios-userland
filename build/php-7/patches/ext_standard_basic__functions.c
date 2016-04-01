--- php-7.0.5/ext/standard/basic_functions.c.orig	2015-06-23 17:33:33.000000000 +0000
+++ php-7.0.5/ext/standard/basic_functions.c
@@ -3499,7 +3499,7 @@ PHPAPI double php_get_nan(void) /* {{{ *
 
 PHPAPI double php_get_inf(void) /* {{{ */
 {
-#if HAVE_HUGE_VAL_INF
+#if defined(HAVE_HUGE_VAL_INF) || defined(__vax__)
 	return HUGE_VAL;
 #elif defined(__i386__) || defined(_X86_) || defined(ALPHA) || defined(_ALPHA) || defined(__alpha)
 	double val = 0.0;
