#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

require IO::All;

IO::All->import('io');

io()->file('Makefile')->print("include lib/make/_Main.mak\n");

1;

