#!/usr/bin/env perl

use strict;
use warnings;

use constant {
    HAPROXY => '/usr/sbin/haproxy',
    PIDFILE => '/var/run/haproxy.pid',
    CONFIG  => '/etc/haproxy/haproxy.cfg',
    ENTRY   => "    server %s %s:80 check\n",
    LOCK    => '/var/lock/serf_handler',
    RETRY   => 10,
    MESSAGE => '/var/log/serf_handler_message.log',
};

exit 0 if $ENV{SERF_TAG_ROLE} ne 'lb';

sub member_info {
    my @members = ();
    while (<STDIN>) {
        my $member = {};
        ( $member->{node}, $member->{ip}, $member->{role} ) = split /\s+/, $_;
        push @members, $member;
    }
    return \@members;
}

my $members = member_info();

my $retry = RETRY;
while ( !symlink( ".", LOCK ) ) {
    if (--$retry <= 0) { exit 1 }
    sleep(1);
}

eval {
    my $event = $ENV{SERF_EVENT};

    my $updated = 0;
    for my $info (@$members) {
        next if $info->{role} ne 'app';

        if ( $event eq 'member-join' ) {
            $updated++;
            open my $fh, '>>', CONFIG
            or die "Faild to open " . CONFIG . ": $!";
            printf $fh ENTRY, $info->{node}, $info->{ip};
            close $fh;
        }
        elsif ( $event eq 'member-leave' || $event eq 'member-failed') {
            $updated++;
            my $server = sprintf ENTRY, $info->{node}, $info->{ip};
            my @config = do {
                open my $fh, '<', CONFIG
                or die "Faild to open " . CONFIG . ": $!";
                my @lines = <$fh>;
                close $fh;
                @lines;
            };
            @config = grep { $_ ne $server } @config;
            open my $fh, '>', CONFIG
            or die "Faild to open " . CONFIG . ": $!";
            map { print $fh $_ } @config;
            close $fh;
        }
    }

    return unless $updated;

    my @cmd = ( HAPROXY, '-f', CONFIG, '-p', PIDFILE, '-D' );
    if ( -e PIDFILE ) {
        my $pid = do {
            open my $fh, '<', PIDFILE
            or die "Faild to open " . PIDFILE . ": $!";
            my $pid = <$fh>;
            close $fh;
            $pid;
        };
        push @cmd, '-sf', $pid;
    }

    system @cmd;
};

unlink LOCK;

die $@ if $@;
