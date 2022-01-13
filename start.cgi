#!/usr/local/bin/perl
# start.cgi
# Start the upsd daemon

require './nutmonitor-lib.pl';
&ReadParse();
&error_setup($text{'start_err'});
$err = &start_nut();
&error($err) if ($err);
&webmin_log("start");
&redirect("");
