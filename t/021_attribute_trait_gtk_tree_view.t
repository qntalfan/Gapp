use Test::More 'no_plan';
use warnings;
use strict;

package Foo;
use Test::More;

use Gapp;
use MooseX::Method::Signatures;

widget 'tree_view' => (
    is => 'rw',
    traits => [qw( GtkTreeView )],
    columns => [
        { label => 'name', display => 'name' }
    ],
);

package main;

my $o = Foo->new;
ok $o, 'created object';

1;
