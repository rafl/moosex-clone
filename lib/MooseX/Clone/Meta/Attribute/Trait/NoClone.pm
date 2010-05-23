#!/usr/bin/perl

package MooseX::Clone::Meta::Attribute::Trait::NoClone;
# ABSTRACT: A trait for attrs that should not be copied while cloning

use Moose::Role;

use namespace::clean -except => [qw(meta)];

with qw(MooseX::Clone::Meta::Attribute::Trait::Clone::Base);

sub Moose::Meta::Attribute::Custom::Trait::NoClone::register_implementation { __PACKAGE__ }

sub clone_value {
    my ( $self, $target, $proto, %args ) = @_;

    # FIXME default cloning behavior works like this
    #if ( exists $args{init_arg} ) {
    #   $self->set_value($args{init_arg});
    #} else {
    # but i think this is more correct

    $self->clear_value($target);
    $self->initialize_instance_slot(
        $self->meta->get_meta_instance,
        $target,
        { exists $args{init_arg} ? ( $self->init_arg => $args{init_arg} ) : () },
    );
}

__PACKAGE__;

=head1 SYNOPSIS

    with qw(MooseX::Clone);

    has _some_special_thingy => (
        traits => [qw(NoClone)],
    );

=head1 DESCRIPTION

Sometimes certain values should not be carried over when cloning an object.

This attribute trait implements just that.

=method clone_value

If the C<init_arg> param is set (that means an explicit value was given to
C<clone>) sets the attribute to that value.

Otherwise calls C<clear_value> and C<initialize_instance_slot>.

=cut
