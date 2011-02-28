package Gapp::Types;

use MooseX::Types -declare => [qw(
GappAction
GappCellRenderer
GappTreeViewColumn
GappUIManager
)];

use MooseX::Types::Moose qw( ArrayRef ClassName CodeRef HashRef Int Str );

# GappAction
class_type GappAction,
    { class => 'Gapp::Action' };

# GappCellRenderer
class_type GappCellRenderer,
    { class => 'Gapp::CellRenderer' };


    my %RENDERERS = (
        'text'   => [ 'Gtk2::CellRendererText', 'text' ],
        'markup' => [ 'Gtk2::CellRendererText', 'markup' ],
        'toggle' => [ 'Gtk2::CellRendererToggle', 'active' ],
    );

    coerce GappCellRenderer,
        from Str,
        via {
            if ( exists $RENDERERS{ $_ } ) {
                my ( $c, $p ) = ( @{ $RENDERERS{ $_ } } );
                'Gapp::CellRenderer'->new( class => $c, property => $p );
            }
        };
    
    coerce GappCellRenderer,
        from HashRef,
        via { 'Gapp::CellRenderer'->new( %$_ ) };
    
    coerce GappCellRenderer,
        from ArrayRef,
        via { 'Gapp::CellRenderer'->new( class => $_->[0], property => $_->[1] ) };


# GappTreeViewColumn
class_type GappTreeViewColumn,
    { class => 'Gapp::TreeViewColumn' };

coerce GappTreeViewColumn,
    from HashRef,
    via { 'Gapp::TreeViewColumn'->new( %$_ ) };
    
coerce GappTreeViewColumn,
    from ArrayRef,
    via {
        my $input = $_;
        my %args;
        $args{name} = $input->[0] if defined $input->[0];
        $args{title} = $input->[1] if defined $input->[1];
        $args{renderer} = $input->[2] || 'text';
        $args{data_column} = $input->[3];
        
        # determine how to display the content
        if ( defined $input->[4] ) {
            $args{data_func} = $input->[4];
        }
        
        %args = (%args, %{ $input->[5] }) if defined $input->[5];
        return 'Gapp::TreeViewColumn'->new( %args );
    };

# GappUIManager
class_type GappUIManager,
    { class => 'Gapp::UIManager' };

coerce GappUIManager,
    from HashRef,
    via { 'Gapp::UIManager'->new( %$_ ) };
    
#
#class_type GtkWidget,
#    { class => 'Gtk2::Widget' };
#    
#class_type MetaGtkAssistantPage,
#    { class => 'Gapp::Meta::GtkAssistantPage' };
#    
#    coerce MetaGtkAssistantPage,
#       from HashRef,
#       via { 'Gapp::Meta::TreeViewColumn'->new( %$_ ) };
#
#    coerce MetaGtkAssistantPage,
#        from ArrayRef,
#        via {
#            my $input = $_;
#            my %args;
#            $args{name}  = $input->[0] if defined $input->[0];
#            $args{title} = $input->[1] if defined $input->[1];
#            $args{type}  = $input->[2] if defined $input->[2];
#            $args{icon}  = $input->[3] if defined $input->[3];
#            $args{build} = $input->[4] if is_CodeRef( $input->[4] );
#            %args = (%args, %{ $input->[5] }) if defined $input->[5];
#            
#            my $pclass = is_ClassName( $input->[4] ) ? $input->[4] : 'Gapp::Meta::GtkAssistantPage';
#            return $pclass->new( %args );
#        };
#
#
#class_type MetaTreeViewColumn,
#    { class => 'Gapp::Meta::TreeViewColumn' };
#
#
#{
#
#    my %RENDERER = (
#        'text'   => [ 'Gtk2::CellRendererText', 'text' ],
#        'markup' => [ 'Gtk2::CellRendererText', 'markup' ],
#        'toggle' => [ 'Gtk2::CellRendererToggle', 'active' ],
#    );
#

#}

1;
