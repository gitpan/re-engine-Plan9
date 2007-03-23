use strict;
use Test::More tests => 2;
use re::engine::Plan9;

# /s

"x\ny" =~ /x.y/
    ? fail ". matched \\n"
    : pass ". didn't match \\n";

"x\ny" =~ /x.y/s
    ? pass ". matched \\n"
    : fail ". didn't match \\n";

# /x

# XXX: How do I test this? / seems to eqv /x
#q(*+?[]()|\^$) =~ /*+?[]()|\^$)/x;
