use strict;
use inc::Module::Install;

name 're-engine-Plan9';

# Requires the unreleased match vars features in (as of writing)
# unreleased 5.9.6, but 5.9.5 is the version of blead
perl_version '5.009005';

author 'Ævar Arnfjörð Bjarmason <avar@cpan.org>';
abstract_from 'Plan9.pm';
license_from 'Plan9.pm';

# t/
build_requires 'Test::More' => 0; # 5.007003

system 'for i in lib*; do cd $i && make clean && cd ..; done';
system 'for i in lib*; do cd $i && make && cd ..; done';

makemaker_args INC => join ' ', map { "-I$_" } glob 'lib*';
makemaker_args LDDLFLAGS => '-shared lib*/*.o';
makemaker_args clean => {
    FILES => join ' ', map { "$_/*.o $_/*.a" } glob "lib*",
};

tests 't/*.t';

auto_install;
WriteAll;

__END__
package MY;

sub postamble
{
    return <<END
all:: libfmt/libfmt.a

libfmt/libfmt.a:
	echo OOOOOOOOOOOOOOO

libutf/libutf.a:
	echo OOOOOOOOOOOOOOO

libregexp/libregexp9.a:
	echo OOOOOOOOOOOOOOO

END
}
__END__
#    my $orig = shift->SUPER::top_targets(@_);
    my $mine = <<END
all :: 

END
    die $orig;
}
__END__
sub top_targets {
    my $orig = shift->SUPER::top_targets(@_);
#    die $orig;
    $orig =~ s[\$\(NOECHO\) \$\(NOOP\)][for i in lib*; do cd \$i && make && cd ..; done];
#    $orig =~ s/[A-Z]/dongs/g;
    $orig;
}
