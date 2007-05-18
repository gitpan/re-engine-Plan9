use strict;
use Test::More tests => 2;
use re::engine::Plan9;

my ($a, $b) = split /(:)/, "a:b";
is($a, "a");

SKIP: {
    skip "Known bug, there are nparens between each match variable", 1;

    is($b, "b");
}
