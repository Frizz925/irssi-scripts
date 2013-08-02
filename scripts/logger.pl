#!/usr/bin/perl

my @channels = ("#indonesian", "#osu", "#osumania", "#malaysian");
my @ignores = ("alvinheriadi", "082389105667");
my $dir = "/srv/http/logs";

sub printToLog {
	my ($filename, $string, $ext) = @_;
	$logtime = `date +%Y%m%d | tr -d '\n'`;
	$filename = "$filename\_$logtime$ext";
	$string = quotemeta($string);
	`echo $string >> $filename`;
}

sub msg_join_log {
	my ($server, $chan, $nick, $address) = @_;
	my $time = localtime;
	my $string = "[$time] $nick $address";
	my $filename = "$dir/$chan";
	printToLog("$filename", "$string", ".joins.log");
#	foreach (@channels) {
#		Irssi::signal_stop() if ($channel =~ /$_/);
#	}
}
Irssi::signal_add('message join', 'msg_join_log');

sub msg_public_log {
	my ($server, $msg, $nick, $address, $chan) = @_;
	my $time = localtime;
	my $string = "[$time] $nick $msg";
	my $filename = "$dir/$chan";
	printToLog("$filename", "$string", ".pubmsg.log");
#	foreach (@ignores) {
#		Irssi::signal_stop() if ($nick =~ /$_/);
#	}
}

sub msg_own_public_log {
	my ($server, $msg, $chan) = @_;
	my $nick = $server->{nick};
	my $time = localtime;
	my $string = "[$time] $nick $msg";
	my $filename = "$dir/$chan";
	printToLog("$filename", "$string", ".pubmsg.log");
}

sub msg_action_log {
	my ($server, $msg, $nick, $address, $chan) = @_;
	my $time = localtime;
	my $string = "[$time] * $nick $msg";
	my $filename = "$dir/$chan";
	printToLog("$filename", "$string", ".pubmsg.log");
#	foreach (@ignores) {
#		Irssi::signal_stop() if ($nick =~ /$_/);
#	}
}

sub msg_own_action_log {
	my ($server, $msg, $chan) = @_;
	my $nick = $server->{nick};
	my $time = localtime;
	my $string = "[$time] * $nick $msg";
	my $filename = "$dir/$chan";
	printToLog("$filename", "$string", ".pubmsg.log");
}

Irssi::signal_add('message irc own_action', 'msg_own_action_log');
Irssi::signal_add('message public', 'msg_public_log');
Irssi::signal_add('message own_public', 'msg_own_public_log');
Irssi::signal_add('message irc action', 'msg_action_log');
