#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'App::Uberwatch' ) || print "Bail out!\n";
}

diag( "Testing App::Uberwatch $App::Uberwatch::VERSION, Perl $], $^X" );
