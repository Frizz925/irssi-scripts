#!/usr/bin/perl -w

my $timeout = time;
my $grantednick;
my $password = "MD5_PASSWORD_HERE";

sub msg_private_rcon {
	my ($server, $msg, $nick, $address) = @_;
	my @string = split(' ', $msg, 2);
	
	if ($string[0] =~ /auth/) {
		my $passkey = `printf "$string[1]" | md5sum`;
		if ($passkey =~ /$password/ and $timeout <= time) {
			Irssi::print("[rcon] $nick access granted for 15 minutes.");
			$server->command("MSG $nick rcon access granted for 15 minutes.");
			$timeout = time + 900;
			$grantednick = $nick;
		}
	}
	
	if ($nick =~ /$grantednick/ and $timeout >= time) {
		if ($string[0] =~ /cmd/) {
			Irssi::print("[rcon] $nick cmd: ".$string[1]);
			$server->command("MSG $nick ".`$string[1]`);
		}
		if ($msg =~ /unauth/) {
			Irssi::print("[rcon] $nick access revoked.");
			$server->command("MSG $nick rcon access revoked.");
			$timeout = time;
		}
	}
}
Irssi::signal_add('message private', 'msg_private_rcon');
