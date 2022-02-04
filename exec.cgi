#!/usr/local/bin/perl
# exec.cgi
# Execute ups command

require './nutmonitor-lib.pl';
&ReadParse();
&error_setup("$text{'exec_err'} [$in{'nut'}]");
$err = &exec_nut();
&error($err) if ($err);
&webmin_log("exec");
&redirect("");
