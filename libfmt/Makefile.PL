use ExtUtils::MakeMaker;

my @C = grep { not /test/ } glob "*.c";
my $object = join " ", map { s/\.c$/\$(OBJ_EXT)/; $_ } @C;

WriteMakefile(
    NAME => 'libfmt',
    C => [ @C ],
    OBJECT => $object,
    INC => '-I. -I../libutf',
);
