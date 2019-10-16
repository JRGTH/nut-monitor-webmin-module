#!/usr/local/bin/perl
# restart.cgi
# Restart the upsd daemon

require './nut-lib.pl';
&ReadParse();
&error_setup($text{'restart_err'});
$err = &restart_nut();
&error($err) if ($err);
&webmin_log("restart");
&redirect("");
