use strict;
use Test::More tests => 16;
use re::engine::Plan9;

{
    my ($a, $b, $c) = split /(:)/, "a:b";
    is($a, "a");
    is($b, ":");
    is($c, "b");
}

# / /, not a special case
{
    my ($a, $b, $c, $d, $e) = split / /, " foo bar ";
    is($a, "");
    is($b, "foo");
    is($c, "bar");
    is($d, "");
    is($e, undef);
}

# The " " special case
{
    my ($a, $b, $c, $d, $e) = split " ", " foo bar  zar ";
    is($a, "foo");
    is($b, "bar");
    is($c, "zar");
    is($d, "");
    is($e, undef);
}

# The /^/ special case
{
    my ($a, $b, $c) = split /^/, "a\nb\nc\n";
    is($a, "a\n");
    is($b, "b\n");
    is($c, "c\n");
}

# The /\s+/ optimization isn't used
