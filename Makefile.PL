use strict;
use inc::Module::Install;

name 're-engine-Plan9';

perl_version '5.009005';

author 'Ævar Arnfjörð Bjarmason <avar@cpan.org>';
abstract_from 'Plan9.pm';
license_from 'Plan9.pm';

# t/
build_requires 'XSLoader'   => 0;
build_requires 'Test::More' => 0; # 5.007003

makemaker_args INC => join ' ', map { "-I$_" } glob 'lib*';
makemaker_args LDDLFLAGS => '-shared lib*/*.o';
makemaker_args clean => {
    FILES => join ' ', map { "$_/*.o $_/*.a" } glob "lib*",
};

tests 't/*.t';

auto_install;
WriteAll;

package MY;

sub postamble
{
    return <<'END'
subdirs :: libfmt/libfmt.a libutf/libutf.a libregexp/libregexp9.a

libfmt/libfmt.a:
	(cd libfmt; $(MAKE))

libutf/libutf.a:
	(cd libutf; $(MAKE))

libregexp/libregexp9.a:
	(cd libregexp; $(MAKE))

END
}
