#!/usr/bin/perl

package MooseX::Clone::Meta::Attribute::Trait::StrableClone;
# ABSTRACT: Moose::Meta::Attribute trait for deeply cloning attributes using Storable

use Moose::Role;

use Carp qw(croak);

use namespace::clean -except => 'meta';

with qw(MooseX::Clone::Meta::Attribute::Trait::Clone::Std);

sub Moose::Meta::Attribute::Custom::Trait::StorableClone::register_implementation { __PACKAGE__ }

sub clone_value_data {
    my ( $self, $value, @args ) = @_;

    if ( ref($value) ) {
        require Storable;
        return Storable::dclone($value);
    } else {
        return $value;
    }
}

__PACKAGE__;

=pod

=encoding utf8

=head1 SYNOPSIS

    # see MooseX::Clone

    has foo => (
        traits => [qw(StorableClone)],
        isa => "Something",
    );

    my $clone = $object->clone; # $clone->foo will equal Storable::dclone($object->foo)

=head1 DESCRIPTION

This meta attribute trait provides a C<clone_value> method, in the spirit of
C<get_value> and C<set_value>. This allows clone methods such as the one in
L<MooseX::Clone> to make use of this per-attribute cloning behavior.

=head1 DERIVATION

Deriving this role for your own cloning purposes is encouraged.

This will allow your fine grained cloning semantics to interact with
L<MooseX::Clone> in the Right™ way.

=attr clone_only_objects

Whether or not L<Data::Visitor> should be used to clone arbitrary structures.
Objects found in these structures will be cloned using L<clone_object_value>.

If true then non object values will be copied over in shallow cloning semantics
(shared reference).

Defaults to false (all reference will be cloned).

=attr clone_visitor_config

A hash ref used to construct C<clone_visitor>. Defaults to the empty ref.

This can be used to alter the cloning behavior for non object values.

=attr clone_visitor

The L<Data::Visitor::Callback> object that will be used to clone.

It has an C<object> handler that delegates to C<clone_object_value> and sets
C<tied_as_objects> to true in order to deeply clone tied structures while
retaining magic.

Only used if C<clone_only_objects> is false and the value of the attribute is
not an object.

=method clone_value $target, $proto, %args

Clones the value the attribute encapsulates from C<$proto> into C<$target>.

=method clone_value_data $value, %args

Does the actual cloning of the value data by delegating to a C<clone> method on
the object if any.

If the object does not support a C<clone> method an error is thrown.

If the value is not an object then it will not be cloned.

In the future support for deep cloning of simple refs will be added too.

=method clone_object_value $object, %args

This is the actual workhorse of C<clone_value_data>.

=method clone_any_value $value, %args

Uses C<clone_visitor> to clone all non object values.

Called from C<clone_value_data> if the value is not an object and
C<clone_only_objects> is false.

=cut
