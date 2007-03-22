use strict;

use Test::More tests => 2;

use re::engine::Plan9;

my $re = qr/aoeu/;

is(ref $re, "Regexp");
is("$re", "aoeu");
