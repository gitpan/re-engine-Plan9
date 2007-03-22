package re::engine::Plan9;
use 5.009005;
use strict;
use XSLoader;
use vars qw($VERSION);

BEGIN
{
    $VERSION = '0.01';
    XSLoader::load __PACKAGE__, $VERSION;
}

use constant PLAN9_ENGINE => get_plan9_engine();

sub import
{
    $^H{regcomp} = PLAN9_ENGINE;
}

sub unimport
{
    delete $^H{regcomp} if $^H{regcomp} == PLAN9_ENGINE;
}

1;

__END__

=head1 NAME

re::engine::Plan9 - Plan9 regular expression engine

=head1 SYNOPSIS

    use re::engine::Plan9;

    if ("bewb" =~ /(.)(.)/) {
        print $1; # b
        print $2; # e
        print $'; # wb
    }

=head1 DESCRIPTION

Replaces perl's regexes in a given lexical scope with Plan9 regular
expression provided by libregexp9. libregexp9 and the libraries it
depends on are shipped with the module.

=head1 CAVEATS

The Plan 9 engine expects the user to supply a pre-allocated buffer to
C<regexec> to hold match variables, however it provides no way to know
how many match variables the pattern needs. Currently 50 match
variables are allocated for every pattern match (includes C<< $& >> so
they go up to C<< $49 >>). Patches that fix the supplied libregexp9 so
that it provides this information to its caller welcome.

=head1 BUGS

C<//g> will make perl do naughty things, fix.

The build system builds the F<lib*> stuff at C<< perl Makefile.PL >>
time rather than C<< make >> time. Due for a fix.

=head1 SEE ALSO

L<http://swtch.com/plan9port/unix/>

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE

Copyright 2007 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
