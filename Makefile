# Copyright (c) Hercules Dev Team, licensed under GNU GPL.
# See the LICENSE file

# Makefile.  Generated from Makefile.in by configure.



HAVE_MYSQL=yes
ifeq ($(HAVE_MYSQL),yes)
	ALL_DEPENDS=common_sql login_sql char_sql map_sql tools sysinfo | import
	SQL_DEPENDS=common_sql login_sql char_sql map_sql sysinfo | import
	COMMON_SQL_DEPENDS=mt19937ar libconfig sysinfo
	LOGIN_SQL_DEPENDS=mt19937ar libconfig common_sql sysinfo
	CHAR_SQL_DEPENDS=mt19937ar libconfig common_sql sysinfo
	MAP_SQL_DEPENDS=mt19937ar libconfig common_sql sysinfo
	TOOLS_DEPENDS=mt19937ar libconfig common_sql sysinfo
else
	ALL_DEPENDS=needs_mysql
	SQL_DEPENDS=needs_mysql
	COMMON_SQL_DEPENDS=needs_mysql
	LOGIN_SQL_DEPENDS=needs_mysql
	CHAR_SQL_DEPENDS=needs_mysql
	MAP_SQL_DEPENDS=needs_mysql
	TOOLS_DEPENDS=needs_mysql
endif

WITH_PLUGINS=yes
ifeq ($(WITH_PLUGINS),yes)
	ALL_DEPENDS+=plugins
	PLUGIN_DEPENDS=common_sql
else
	PLUGIN_DEPENDS=no_plugins
endif

HAVE_PERL=yes
HAVE_DOXYGEN=no

MF_TARGETS = Makefile $(addsuffix /Makefile, src/common 3rdparty/mt19937ar \
             3rdparty/libconfig src/char src/login src/map src/plugins \
             src/tool src/test tools/HPMHookGen)

CC = gcc
export CC

#####################################################################
.PHONY: sql  \
	common_sql \
	mt19937ar \
	login_sql \
	char_sql \
	map_sql \
	tools \
	plugins \
	import \
	test \
	clean \
	buildclean \
	distclean \
	sysinfo \
	hooks \
	help

all: $(ALL_DEPENDS)

sql: $(SQL_DEPENDS)

$(MF_TARGETS): %: %.in
	@echo "	CONFIGURE"
	@if [ -x config.status ]; then \
		echo "Reconfiguring with options: $$(./config.status --config)"; \
		./config.status; \
	else \
		echo "Unable to find a previous config.status.  ./configure will be re-run with the default options."; \
		echo "If you want to use custom options, please press CTRL-C and run ./configure yourself"; \
		for i in 1 2 3 4 5 6 7 8 9 10; do \
			printf "\a. "; \
			sleep 1; \
		done; \
		echo ""; \
		./configure; \
	fi;

common_sql: $(COMMON_SQL_DEPENDS) src/common/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/common sql

mt19937ar: 3rdparty/mt19937ar/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C 3rdparty/mt19937ar

libconfig: 3rdparty/libconfig/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C 3rdparty/libconfig

login_sql: $(LOGIN_SQL_DEPENDS) src/login/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/login sql

char_sql: $(CHAR_SQL_DEPENDS) src/char/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/char

map_sql: $(MAP_SQL_DEPENDS) src/map/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/map sql

tools: $(TOOLS_DEPENDS) src/tool/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/tool

test: src/test/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/test

plugins: $(PLUGIN_DEPENDS) src/plugins/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/plugins

plugin.%: $(PLUGIN_DEPENDS) src/plugins/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C src/plugins $(patsubst plugin.%,%,$@)

hooks: tools/HPMHookGen/Makefile
	@echo "	MAKE	$@"
	@$(MAKE) -C tools/HPMHookGen

import: Makefile
	@# 1) create conf/import folder
	@# 2) add missing files
	@echo "building conf/import folder..."
	@if test ! -d conf/import ; then mkdir conf/import ; fi
	@for f in $$(ls conf/import-tmpl) ; do if test ! -e conf/import/$$f ; then cp conf/import-tmpl/$$f conf/import ; fi ; done

clean buildclean: $(MF_TARGETS)
	@$(MAKE) -C src/common $@
	@$(MAKE) -C 3rdparty/mt19937ar $@
	@$(MAKE) -C 3rdparty/libconfig $@
	@$(MAKE) -C src/login $@
	@$(MAKE) -C src/char $@
	@$(MAKE) -C src/map $@
	@$(MAKE) -C src/plugins $@
	@$(MAKE) -C src/tool $@
	@$(MAKE) -C src/test $@
	@$(MAKE) -C tools/HPMHookGen $@

distclean: clean
	@-rm -f $(MF_TARGETS) config.status config.log

sysinfo: config.status
	@./sysinfogen.sh src/common/sysinfo_new.inc -g -O2 -pipe -ffast-math -fvisibility=hidden -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wno-clobbered -Wempty-body -Wformat-security -Wno-format-nonliteral -Wno-switch -Wno-missing-field-initializers -Wshadow -fno-strict-aliasing -DHAVE_EXECINFO  -DMAXCONN=16384 -I../common -DHAS_TLS -DHAVE_SETRLIMIT -DHAVE_STRNLEN -I/usr/include -DHAVE_MONOTONIC_CLOCK
	@if cmp -s src/common/sysinfo.inc src/common/sysinfo_new.inc; then \
		rm src/common/sysinfo_new.inc ; \
	else \
		mv src/common/sysinfo_new.inc src/common/sysinfo.inc ; \
	fi

config.status: configure
	@echo "	RECONFIGURE"
	@./config.status --recheck && ./config.status

help: Makefile
	@echo "most common targets are 'all' 'sql' 'clean' 'plugins' 'help'"
	@echo "possible targets are:"
	@echo "'common_sql'  - builds object files used in SQL servers"
	@echo "'mt19937ar'   - builds object file of Mersenne Twister MT19937"
	@echo "'libconfig'   - builds object files of libconfig"
	@echo "'login_sql'   - builds login server"
	@echo "'char_sql'    - builds char server"
	@echo "'map_sql'     - builds map server"
	@echo "'tools'       - builds all the tools in src/tools"
	@echo "'import'      - builds conf/import folder from the template conf/import-tmpl"
	@echo "'all'         - builds all the above targets"
	@echo "'sql'         - builds sql servers (targets 'common_sql' 'login_sql' 'char_sql'"
	@echo "                'map_sql' and 'import')"
	@echo "'plugins'     - builds all available plugins"
	@echo "'plugin.Name' - builds plugin named 'Name'"
	@echo "'test'        - builds tests"
	@echo "'clean'       - cleans executables and objects"
	@echo "'buildclean'  - cleans build temporary (object) files, without deleting the"
	@echo "                executables"
	@echo "'distclean'   - cleans files generated by ./configure"
	@echo "'sysinfo'     - re-generates the System Info include"
ifeq ($(HAVE_PERL)$(HAVE_DOXYGEN),yesyes)
	@echo "'hooks'       - re-generates the definitions for the HPM"
endif
	@echo "'help'        - outputs this message"

#####################################################################

needs_mysql:
	@echo "MySQL not found or disabled by the configure script"
	@exit 1

no_plugins:
	@echo "Plugins disabled by the configure script"
	@exit 1
