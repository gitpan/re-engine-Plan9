use strict;
use Test::More skip_all => "TODO";
use re::engine::Plan9;

$_ = 'x' x 20; 
$snum = s/([0-9]*|x)/<$1>/g; 
$foo = '<>' . ('<x><>' x 20) ;
ok( $_ eq $foo && $snum == 41 );
