package Gapp::Moose::Meta::Attribute::Trait::GappToggleToolButton;
use Moose::Role;

before '_process_options' => sub {
    my ( $class, $name, $opts ) = @_;
    $opts->{gclass} = 'Gapp::ToggleToolButton' if ! exists $opts->{class};
};

package Moose::Meta::Attribute::Custom::Trait::GappToggleToolButton;
sub register_implementation { 'Gapp::Moose::Meta::Attribute::Trait::GappToggleToolButton' };
1;
