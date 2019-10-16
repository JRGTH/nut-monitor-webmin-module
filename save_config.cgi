#!/usr/local/bin/perl
# save_config.cgi
# Update a manually edited config file

require './nut-lib.pl';
&error_setup($text{'manual_err'});
&ReadParseMime();

@files = ( "$config{'nut_confpath'}/nut.conf", "$config{'nut_confpath'}/ups.conf", "$config{'nut_confpath'}/upsd.conf",
	"$config{'nut_confpath'}/upsd.users", "$config{'nut_confpath'}/upsmon.conf", "$config{'nut_confpath'}/upssched.conf" );
&indexof($in{'file'}, @files) >= 0 || &error($text{'manual_efile'});
$in{'data'} =~ s/\r//g;
$in{'data'} =~ /\S/ || &error($text{'manual_edata'});

# Write to it
&open_lock_tempfile(DATA, ">$in{'file'}");
&print_tempfile(DATA, $in{'data'});
&close_tempfile(DATA);

&webmin_log("manual", undef, $in{'file'});
&redirect("");
