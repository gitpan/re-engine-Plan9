use strict;

#sub is { shift eq shift }
use Test::More tests => 3;
use re::engine::Plan9;

my $_;

$_ = "ab";
s/a//;
is($_, 'b');

$_ = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
s/.//g;
is($_, '');

$_ = "aabbc";
s/..//g;
is($_, 'c');


