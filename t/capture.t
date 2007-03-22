use strict;

use Test::More 'no_plan';

use re::engine::Plan9;

unless ("eep aoeu 420 eek" =~ /(.)(.)(.)(.) ([0-9]+)/) {
    fail "didn't match";
} else {
    pass "matched";

    is($`, "eep ");
    is($', " eek");
    is($&, "aoeu 420", '$&');

    is($1, "a");
    is($2, "o");
    is($3, "e");
    is($4, "u");
    is($5, "420");
    is($6, undef);
    is($640, undef);
}
