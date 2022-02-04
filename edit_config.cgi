#!/usr/local/bin/perl
# edit_config.cgi
# Show a page for manually editing an NUT config file

require './nutmonitor-lib.pl';
&ReadParse();
&ui_print_header(undef, $text{'index_title'}, "");

@files = ( "$config{'nut_confpath'}/nut.conf", "$config{'nut_confpath'}/ups.conf", "$config{'nut_confpath'}/upsd.conf",
	"$config{'nut_confpath'}/upsd.users", "$config{'nut_confpath'}/upsmon.conf", "$config{'nut_confpath'}/upssched.conf", "$config{'upsschedcmd_path'}");
$in{'file'} ||= $files[0];
&indexof($in{'file'}, @files) >= 0 || &error($text{'manual_efile'});
print &ui_form_start("edit_config.cgi");
print "<b>$text{'manual_file'}</b>\n";
print &ui_select("file", $in{'file'},
		 [ map { [ $_ ] } @files ]),"\n";
print &ui_submit($text{'manual_ok'});
print &ui_form_end();

# Show the file contents
print &ui_form_start("save_perconfig.cgi", "form-data");
print &ui_hidden("file", $in{'file'}),"\n";
$data = &read_file_contents($in{'file'});
print &ui_textarea("data", $data, 20, 80),"\n";
print "<b>$text{'manual_editnote'}<b>";
print &ui_form_end([ [ "save", $text{'save'} ] ]);

&ui_print_footer("", $text{'index_return'});
