#!/usr/bin/perl
use warnings;
use strict;

use Data::Dump qw(dump);
use List::Util qw(min);

my $in_table;
my @t;
my $table;

my @svg;

while(<>) {
	chomp;
	s/\r$//;

	if (/^Table/) {
		@t = split(/,/,$_);
		$in_table = $t[0];
		#warn "## t=",dump( \@t );
	} elsif ( m/^$/ ) {
		$in_table = undef;
	} elsif ( $in_table ) {
		my @v = split(/,/,$_);
		#warn "## v=",dump( \@v );
		my %hash;
		@hash{@t} = @v;
		#warn "# ",dump( \%hash );
		push @{ $table->{ $v[0] } }, \%hash;
		if ( $v[0] eq 'Station' ) {
			$table->{ station_by_id }->{ $v[2] } = \%hash;
		}
	} else {
		warn "IGNORE: $_\n";
	}
}


warn "# table = ",dump( $table );

# feeder positions
my $x = 10;
my $y = 100;

sub cx_cy_s {
	my ( $x, $y, $w, $h ) = @_;

	my $min = $w;
	$min = $h if $h < $min;

	my $s = $min / 4;
	my $cx = $x + $s;
	my $cy = $y + $s;

	return ( $cx, $cy, $s );
}

foreach my $station ( @{ $table->{Station} } ) {

	# 160 = 1.6 mm, so 1/100
	my $w = $station->{SizeX} / 100;
	my $h = $station->{SizeY} / 100;

	my $id = $station->{ID};

	my ( $cx, $cy, $s ) = cx_cy_s( $x, $y, $w, $h );
push @svg, qq{
  <g id="station$id">
	<rect x="$x" y="$y" width="$w" height="$h" fill="blue" />
	<circle cx="$cx" cy="$cy" r="$s" fill="red" />
  </g>
};

	$x += $w + 3;
}

my $bbox = { max => { x => 0, y => 0 }, min => { x => 999999999, y => 999999999 } };

foreach my $component ( @{ $table->{EComponent} } ) {

	my $x = $component->{DeltX};
	my $y = $component->{DeltY};
	
	my $angle = $component->{Angle};
	my $id = $component->{'STNo.'};
	my $explain = $component->{Explain};

	my $w = $table->{ station_by_id }->{$id}->{SizeX} / 100;
	my $h = $table->{ station_by_id }->{$id}->{SizeY} / 100;

	$y = 100 - $y;	# flip y axes

	# move coordinates to center
	$x = $x - ( $w / 2 );
	$y = $y - ( $h / 2 );

	my $r_x = $x + ( $w / 2 );
	my $r_y = $y + ( $h / 2 );

	my ( $cx, $cy, $s ) = cx_cy_s( $x, $y, $w, $h );

push @svg, qq{
  <g id="$explain" transform="rotate($angle,$r_x,$r_y)">
	<rect x="$x" y="$y" width="$w" height="$h" fill="gray" />
	<circle cx="$cx" cy="$cy" r="$s" fill="red" />
  </g>
};

	$bbox->{max}->{x} = $x + $w if $x + $w > $bbox->{max}->{x};
	$bbox->{max}->{y} = $y + $h if $y + $h > $bbox->{max}->{y};
	$bbox->{min}->{x} = $x - $w if $x - $w < $bbox->{min}->{x};
	$bbox->{min}->{y} = $y - $h if $y - $h < $bbox->{min}->{y};


}

my $x = $bbox->{min}->{x};
my $y = $bbox->{min}->{y};

my $w = $bbox->{max}->{x} - $bbox->{min}->{x};
my $h = $bbox->{max}->{y} - $bbox->{min}->{y};

push @svg, qq{
<!-- bbox = },dump($bbox), qq{ -->
<rect x="$x" y="$y" width="$w" height="$h" style="fill:blue;opacity:0.2" />
};

warn "# bbox = ",dump($bbox);

# 250 80
#<svg viewBox="0 -100 200 150" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
print qq{
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
};

print @svg;

print qq{
</svg>
};


__END__
  <use xlink:href="#test" x="0" y="10" transform="rotate(15,5,15)" stroke="blue"/>
  <use xlink:href="#test" x="0" y="20" transform="rotate(35,5,25)" stroke="blue"/>
  <use xlink:href="#test" x="0" y="30" transform="rotate(55,5,35)" stroke="blue"/>
  <use xlink:href="#test" x="0" y="40" transform="rotate(75,5,45)" stroke="blue"/>

</svg>

};
