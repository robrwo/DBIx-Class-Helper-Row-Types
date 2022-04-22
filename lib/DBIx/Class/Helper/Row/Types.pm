package DBIx::Class::Helper::Row::Types;

use v5.10;

# ABSTRACT: Use Types to define rows

use strict;
use warnings;

use Ref::Util ();
use Safe::Isa 1.000008 qw/ $_isa $_can $_call_if_can /;
use Types::SQL::Util v0.3.0 ();

# RECOMMEND PREREQ: Ref::Util::XS
# RECOMMEND PREREQ: Type::Tiny::XS

our $VERSION = 'v0.3.1';

=head1 SYNOPSIS

In result class:

  use Types::SQL -types;
  use Types::Standard -types;

 __PACKAGE__->load_components('Helper::Row::Types');

 __PACKAGE__->add_columns(

    id   => Serial,

    name => {
      isa => Maybe[ Varchar[64] ],
    },
 );

=head1 DESCRIPTION

This helper allows you to specify column information by passing a
L<Type::Tiny> object.

Note that this I<does not> enforce that the data is of that type,
unless you specify the C<strict> option (See L</set_column>).  The
main purpose of this is to allow you to use types as a shorthand for
specifying the column type.

You can use types from L<Types::SQL> or supported types from
L<Types::Standard>.

=cut

=method C<add_column>

=method C<add_columns>

These methods are modified to allow you to specify the column info
using the C<isa> attribute and a L<Type::Tiny> type.

Note that in no way does this enforce that type.

=cut

sub add_columns {
    my ( $self, @args ) = @_;

    my @cols = map { $self->_apply_types_to_column_defition($_) } @args;

    $self->next::method(@cols);
}

sub _apply_types_to_column_defition {
    my ( $self, $column_info ) = @_;

    return $column_info unless Ref::Util::is_ref $column_info;

    $column_info = { isa => $column_info }
      if $column_info->$_isa('Type::Tiny');

    my $type = $column_info->{isa} or return $column_info;

    my %info = Types::SQL::Util::column_info_from_type($type);

    @info{ keys %$column_info } = values %$column_info;

    $info{extra} ||= {};
    $info{extra}{type} = {};
    $info{extra}{type}{$_} = delete $info{$_} for qw/ isa strict coerce /;

    return \%info;
}

=method C<set_column>

If the C<strict> attribute is true for the column, then the type
constraint will be enforced when the column is explicitly set.

If the C<coerce> attribute is true, then the type's coercion will be
applied before checking the constraint.

Note that type constraints will not be enforced if you use the
C<insert> or resultset C<create> methods.

This is entirely separate from database-level constraints.

Enabling C<strict> for an inflated column is strongly discouraged.

=cut

sub set_column {
    my ($self, $column, $new_value) = @_;

    if (my $info = $self->result_source->column_info($column)) {

        if (my $type_info = $info->{extra}{type}) {

            my $type = $type_info->{isa};

            if ($type_info->{coerce} && $type->$_can('coerce')) {
                $new_value = $type->coerce($new_value);
            }

            $type->$_call_if_can( assert_valid => $new_value )
                if $type_info->{strict};
        }

    }

    return $self->next::method( $column => $new_value );
}

1;

=head1 KNOWN ISSUES

Strict type constraints are only applied when explicitly setting a
column value.

=head1 SEE ALSO

L<DBIx::Class>

L<Types::SQL>

L<Types::SQL::Util> provides a list of "standard" types that are
supported.

=cut
