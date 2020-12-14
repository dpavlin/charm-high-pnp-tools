#!/usr/bin/perl
use warnings;
use strict;

my $in_table;
my @t;
my $table;

sub col_nr {
	my $col = shift;
	foreach my $i ( 0 .. @t ) {
		return $i if $t[$i] eq $col;
	}
	die "can't find $col";
}

while(<>) {
	chomp;
	s/\r$//;

	if (/^Table/) {
		@t = split(/,/,$_);
		$in_table = $t[0];
	} elsif ( $in_table ) {
		my @v = split(/,/,$_);
		if ( $v[0] eq 'EComponent' ) {
			my $c_x = col_nr('DeltX');
			my $c_y = col_nr('DeltY');

			my $tmp_x = $v[$c_x];
			$v[$c_x] = $v[$c_y];
			$v[$c_y] = $tmp_x;

			my $c_a = col_nr('Angle');
			$v[$c_a] += 90; # FIXME -90?

			print join(',', @v), "\r\n";
			next;
		}
	}
	print "$_\r\n"; # pass-through
}
