#!/usr/local/bin/perl
# nut-lib.pl

BEGIN { push(@INC, ".."); };
use WebminCore;
&init_config();

my $ups_stat_props="$config{'nut_monitor'}";

# Get NUT version
sub get_nut_version
{
my $getversion = 'upsd -V | awk "{print \$5}"';
my $version = `$getversion`;
}

# Get pid file
# Returns the NUT PID file.
sub get_pid_file
{
$pidfile = $config{'pid_file'};
return $pidfile;
}

# Get NUT pid
# Returns the PID of the running NUT process.
sub get_nut_pid
{
local $file = &get_pid_file();
if ($file) {
	return &check_pid_file($file);
	}
else {
	local ($rv) = &find_byname("upsd");
	return $rv;
	}
}

# Kill NUT related processes.
sub kill_nut_procs
{
my $killnutprocs = `pkill -U nut`;
}

sub list_nut
{
my %nut=();
my $list=`upsc $config{'ups_name'} | grep -E "$ups_stat_props"`;
open my $fh, "<", \$list;
while (my $line =<$fh>)
{
	chomp ($line);
	my @props = split(" ", $line, 2);
		$ct = 1;
		foreach $prop (split(",", "VALUE")) {
			$nut{$props[0]}{$prop} = $props[$ct];
			$ct++;
		}

}
return %nut;
}

# NUT summary list.
sub ui_nut_list
{
my %nut = list_nut($nut);
@props = split(/,/, "VALUE");
print &ui_columns_start([ "PROPERTY", @props ]);
my $num = 0;
foreach $key (sort(keys %nut))
{
	@vals = ();
	foreach $prop (@props) { push (@vals, $nut{$key}{$prop}); }
	# Disable start, stop and restart buttons.
	print &ui_columns_row([ "<a href='index.cgi?nut=$key'>$key</a>", @vals ]);
	$num ++;
}
print &ui_columns_end();
}

sub ui_nut_conf
{
# Display icons for options.
if ($config{'show_conf'}) {
	push(@links, "edit_config.cgi");
	push(@titles, $text{'manual_nutedit'});
	push(@icons, "images/manual.gif");
	}
&icons_table(\@links, \@titles, \@icons, 4);
}

# Restart NUT, and returns an error message on failure or
# undef on success.
sub restart_nut
{
if ($config{'restart_cmd'}) {
	local $out = `$config{'restart_cmd'} 2>&1 </dev/null`;
	return "<pre>$out</pre>" if ($?);
	}
else {
	# Just kill NUT related processes and start NUT.
	kill_nut_procs;
	if ($config{'start_cmd'}) {
	$out = &backquote_logged("$config{'start_cmd'} 2>&1 </dev/null");
	if ($?) { return "<pre>$out</pre>"; }
		}
	}
return undef;
}

# Always use stop command whenever possible, otherwise
# try to kill the NUT service, returns an error message on failure or
# undef on success.
sub stop_nut
{
if ($config{'stop_cmd'}) {
	local $out = `$config{'stop_cmd'} 2>&1 </dev/null`;
	return "<pre>$out</pre>" if ($?);
	}
else {
	# Just kill NUT related processes.
	kill_nut_procs;
	}
return undef;
}

# Attempts to start NUT, returning undef on success or an error
# message on failure.
sub start_nut
{
# Remove PID file if invalid.
if (-f $config{'pid_file'} && !&check_pid_file($config{'pid_file'})) {
	&unlink_file($config{'pid_file'});
	}
if ($config{'start_cmd'}) {
	$out = &backquote_logged("$config{'start_cmd'} 2>&1 </dev/null");
	if ($?) { return "<pre>$out</pre>"; }
	}
else {
	$out = &backquote_logged("$config{'pid_file'} 2>&1 </dev/null");
	if ($?) { return "<pre>$out</pre>"; }
	}
return undef;
}

1;
