package Gapp::TreeView;

use Moose;
extends 'Gapp::Container';

use Gapp::Util;
use Gapp::Types qw( GappTreeViewColumn );

use Moose::Util;
use MooseX::Types::Moose qw( ArrayRef HashRef );

has '+gclass' => (
    default => 'Gtk2::TreeView',
);

has 'model' => (
    is => 'rw',
    isa => 'Maybe[Object]',
);

has 'columns' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [ ] },
);

sub BUILDARGS {
    my $class = shift;
    my %args = @_ == 1 && is_HashRef( $_[0] ) ? %{$_[0]} : @_;
    
    # coerce column values if they are not Gapp::TreViewColumn objects
    if ( exists $args{columns} ) {
        
        my @columns;
        
        for my $c ( @{$args{columns}} ) {
            $c = to_GappTreeViewColumn( $c ) if ! is_GappTreeViewColumn( $c );
            push @columns, $c if $c;
        }
        
        $args{columns} = \@columns;
    }
    
    # headers visible
    if ( exists $args{headers_visible} ) {
        $args{properties}{headers_visible} = $args{headers_visible};
        delete $args{headers_visible};
    }
    
    __PACKAGE__->SUPER::BUILDARGS( %args );
}

after '_build_gobject' => sub {
    my $self = shift;

    for my $c ( @{ $self->columns } ) {
        $self->gobject->append_column( $c->gobject );
        $self->gobject->{columns}{$c->name} = $c->gobject;
    }
};

sub find_column {
    my ( $self, $cname ) = @_;
    
    for my $c ( @{ $self->columns } ) {
        if ( $c->name eq $cname ) {
            return $c;
        }
    }
}

1;



__END__

=pod

=head1 NAME

Gapp::TreeView - TreeView Widget

=head1 OBJECT HIERARCHY

=over 4

=item L<Gapp::Object>

=item +-- L<Gapp::Widget>

=item ....+-- L<Gapp::Container>

=item ........+-- L<Gapp::TreeView>

=back

=head1 PROVIDED ATTRIBUTES

=over 4

=item B<model>

=over 4

=item isa L<Gapp::Model>|Undef

=back

=item B<columns>

=over 4

=item isa ArrayRef[L<Gapp::TreeViewColumn>]

=item default []

=back

An array of L<Gapp::TreeViewColumn> objects to be displayed in the view.

=back

=head1 PROVIDED METHODS

=over 4

=item B<find_column $name>

Searches for and returns a column with the specified name.

=over 4

=item returns L<Gapp::TreeViewColumn>|Undef

=back

=back

=head1 AUTHORS

Jeffrey Ray Hallock E<lt>jeffrey.hallock at gmail dot comE<gt>

=head1 COPYRIGHT & LICENSE

    Copyright (c) 2011-2012 Jeffrey Ray Hallock.

    This program is free software; you can redistribute it and/or
    modify it under the same terms as Perl itself.

=cut
