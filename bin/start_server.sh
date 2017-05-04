#!/usr/bin/env sh
set -e

/bin/cat << EOF > ${HOME}/hhvm.ini
date.timezone = UTC
hhvm.enable_obj_destruct_call = true
hhvm.enable_zend_compat = true
hhvm.error_handling.call_user_handler_on_fatals = true
hhvm.hack.lang.iconv_ignore_correct = true
hhvm.jit = true
hhvm.log.always_log_unhandled_exceptions = true
hhvm.log.native_stack_trace = false
hhvm.log.runtime_error_reporting_level = HPHP_ALL
hhvm.log.use_syslog = false
hhvm.pcre_cache_type = lru
hhvm.pid_file =
hhvm.repo.central.path = /tmp/hhvm.hhbc
hhvm.server.apc.expire_on_sets = true
hhvm.server.apc.expire_on_sets = true
hhvm.server.apc.purge_frequency = 4096
hhvm.server.apc.table_type = concurrent
hhvm.server.apc.ttl_limit = 172800
hhvm.server.default_document = index.php
hhvm.server.dns_cache.enable = true
hhvm.server.dns_cache.ttl = 300
hhvm.server.exit_on_bind_fail = true
hhvm.server.port = 8080
hhvm.server.source_root = ${HOME}/public_html
hhvm.server.stat_cache = true
hhvm.server.thread_count = 4
hhvm.server.type = proxygen
hhvm.log.file=${HOME}/hhvm-webservice.log
error_log=${HOME}/hhvm-webservice-error.log
hhvm.hack.lang.look_for_typechecker = false
max_execution_time = 10
memory_limit = 16M
hhvm.log.use_log_file = true
hhvm.log.level = Warning
;hhvm.repo.authoritative = true

EOF

exec /usr/bin/hhvm -m server -c ${HOME}/server.ini -c ${HOME}/hhvm.ini
