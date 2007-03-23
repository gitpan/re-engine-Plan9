package re::engine::Plan9;
use 5.009005;
use strict;
use XSLoader;
use vars qw($VERSION);

BEGIN
{
    $VERSION = '0.03';
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

The C</s>> flag causes C<.> to match a newline (C<regcompnl>) and the
C</x> flag allegedly causes all characters to be treated literally
(C<regcomplit>), see regexp9(3). No other flags have special meaning
to this engine.

If an invalid pattern is supplied perl will die with an error from
regerror(3).

=head1 CAVEATS

The Plan 9 engine expects the user to supply a pre-allocated buffer to
C<regexec> to hold match variables, however it provides no way to know
how many match variables the pattern needs. Currently 50 match
variables are allocated for every pattern match (includes C<< $& >> so
they go up to C<< $49 >>). Patches that fix the supplied libregexp9 so
that it provides this information to its caller welcome.

=head1 BUGS

Some of the semantics of C<< //g >> and C<< s/// >> are broken, see
failing tests for reference.

=head1 SEE ALSO

=over 4

=item regexp9(7) - Plan 9 regular expression notation

L<http://swtch.com/plan9port/unix/man/regexp97.html>

=item regexp9(3) - regcomp, regexec etc.

L<http://swtch.com/plan9port/unix/man/regexp93.html>

=item Unix Software from Plan 9

L<http://swtch.com/plan9port/unix/>

=item An article by Russ Cox applicable to before the release of this library:)

L<http://swtch.com/~rsc/regexp/regexp1.html>

=back

=head1 THANKS

Rafael Kitover (RKITOVER) for the C<< postamble >> F<Makefile.PL>
section that builds the Plan 9 libraries at C<< make >> time.

=head1 AUTHOR

E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason <avar@cpan.org>

=head1 LICENSE

Copyright 2007 E<AElig>var ArnfjE<ouml>rE<eth> Bjarmason.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

The included libutf, libfmt and libregexp9 libraries are provided
under the following license:

    The authors of this software are Rob Pike and Ken Thompson.
                 Copyright (c) 2002 by Lucent Technologies.
    Permission to use, copy, modify, and distribute this software for any
    purpose without fee is hereby granted, provided that this entire notice
    is included in all copies of any software which is or includes a copy
    or modification of this software and in all copies of the supporting
    documentation for such software.
    THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
    WARRANTY.  IN PARTICULAR, NEITHER THE AUTHORS NOR LUCENT TECHNOLOGIES MAKE ANY
    REPRESENTATION OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY
    OF THIS SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.

=cut
