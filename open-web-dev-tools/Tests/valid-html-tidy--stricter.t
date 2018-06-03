#!/usr/bin/perl

use strict;
use warnings;

use Test::HTML::Tidy::Recursive::Strict;

my %whitelist = ( map { $_ => 1 } (), );

Test::HTML::Tidy::Recursive::Strict->new(
    {
        filename_filter => sub {
            my $fn = shift;
            return not(
                exists $whitelist{$fn}
                or $fn =~ m#\A dest/(?: js/jquery-ui/ | tools/ ) #x,
            );
        },
        targets => ['./dest'],
    }
)->run;
