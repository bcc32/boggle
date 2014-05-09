#!/usr/bin/perl -w

use strict;
use Data::Dumper;

use constant moves => (
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1],
);

my $filename = "twl06.txt";
if (@ARGV >= 1) {
    $filename = shift @ARGV;
}

open my $dict, '<', $filename;

sub blank {
    my $rows = shift;
    my $cols = shift;
    my @arr = ();
    my @row = ();

    push @row, '' for (1..$cols);
    push @arr, [@row] for (1..$rows);

    return \@arr;
}

sub match {
    my $ref = shift;                    # ref to boggle board
    my $word = shift;                   # word to match

    my $rows = $#$ref;
    return '' if $rows < 1;
    my $cols = $#{$ref->[0]};

    for my $i (0..$rows) {
        for my $j (0..$cols) {
            return 1 if search($ref, blank($rows + 1, $cols + 1),
                [$rows, $cols], [$i, $j], $word);
        }
    }

    return '';                          # undef is probably implicitly, anyway
}

sub search {  ## TODO FIX Qu behavior
    my $ref = shift;                    # ref to boggle board
    my $vref = shift;                   # ref to visited
    my $dref = shift;                   # ref to anon array of dimensions
    my $iref = shift;                   # ref to anon array of indices
    my $word = shift;                   # word to search form

    return 1 if 0 == length $word;
    return '' if $iref->[0] < 0 || $iref->[0] > $dref->[0] ||
                $iref->[1] < 0 || $iref->[1] > $dref->[1];
    return '' if $vref->[$iref->[0]][$iref->[1]];
    return '' if $ref->[$iref->[0]][$iref->[1]] ne substr $word, 0, 1;

    $vref->[$iref->[0]][$iref->[1]] = 1;

    for my $move (moves) {
        return 1 if search($ref, $vref, $dref,
            [$iref->[0] + $move->[0], $iref->[1] + $move->[1]],
            (substr $word, 1));
    }

    $vref->[$iref->[0]][$iref->[1]] = '';

    return '';
}

my ($n, $m) = split ' ', <>;
my @grid = ();
for (1..$n) {
    my $line = <>;
    chomp $line;
    push @grid, [split //, $line];
}

my @arr = ();

while (<$dict>) {
    chomp;
    push @arr, $_ if length $_ >= $m && match(\@grid, $_);
}

for my $word (sort { length $b <=> length $a } @arr) {
    print $word, "\n";
}
