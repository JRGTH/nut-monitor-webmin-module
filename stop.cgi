#!/usr/local/bin/perl
# stop.cgi
# Stop the upsd daemon

require './nut-lib.pl';
&ReadParse();
&error_setup($text{'stop_err'});
$err = &stop_nut();
&error($err) if ($err);
&webmin_log("stop");
&redirect("");
