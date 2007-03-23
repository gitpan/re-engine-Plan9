use strict;
use Test::More tests => 4;
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

$_ = "abc";
s/./1+1/eg;
is($_, "222");

$_ = "123";
s/(.)/$1+1/eg;
is($_, "234");

