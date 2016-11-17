--- php-7.0.13/sapi/cli/Makefile.frag.orig	2015-06-23 17:33:33.000000000 +0000
+++ php-7.0.13/sapi/cli/Makefile.frag
@@ -2,6 +2,9 @@ cli: $(SAPI_CLI_PATH)
 
 $(SAPI_CLI_PATH): $(PHP_GLOBAL_OBJS) $(PHP_BINARY_OBJS) $(PHP_CLI_OBJS)
 	$(BUILD_CLI)
+	@if test -x /usr/sbin/paxctl; then \
+		/usr/sbin/paxctl +m $(SAPI_CLI_PATH); \
+	fi
 
 install-cli: $(SAPI_CLI_PATH)
 	@echo "Installing PHP CLI binary:        $(INSTALL_ROOT)$(bindir)/"
