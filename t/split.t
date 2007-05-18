use strict;
use Test::More tests => 3;
use re::engine::Plan9;

my ($a, $b, $c) = split /(:)/, "a:b";
is($a, "a");
is($b, ":");
is($c, "b");
