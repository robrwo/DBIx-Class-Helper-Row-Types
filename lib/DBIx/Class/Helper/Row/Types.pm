package DBIx::Class::Helper::Row::Types;

# ABSTRACT: Use Types to define rows

use strict;
use warnings;

use Hash::Merge qw/ merge /;
use Ref::Util qw/ is_ref /;
use Safe::Isa qw/ $_isa /;
use Types::SQL::Util qw/ column_info_from_type /;

our $VERSION = 'v0.1.0';

=for Pod::Coverage VERSION

=cut

sub VERSION { # for older Perls
    require version;
    return version->parse($VERSION);
}

=head1 SYNOPSIS

In result class:

  use Types::SQL -types;

 __PACKAGE__->load_components('Helper::Row::Types');

 __PACKAGE__->add_column(
    name => {
      isa => Maybe[ Varchar[64] ],
    },
 );

=head1 DESCRIPTION

This helper allows you to specify column information by passing a
L<Type::Tiny> object.

Note that this I<does not> enforce that the data is of that type. It
just allows you to use types as a shorthand for specifying the column
info.

A future version may add options to enforce types or coerce data.

=cut

=method C<add_column>

=method C<add_columns>

This allows you to specify the volumn info using the C<isa> attribute
and a L<Type::Tiny> type.

Note that in no way does this enforce that type.

=cut

sub add_columns {
    my ( $self, @args ) = @_;

    my @cols = map { $self->_apply_types_to_column_defition($_) } @args;

    $self->next::method(@cols);
}

sub _apply_types_to_column_defition {
    my ( $self, $column_info ) = @_;

    return $column_info unless is_ref $column_info;

    $column_info = { isa => $column_info }
      if $column_info->$_isa('Type::Tiny');

    my $type = $column_info->{isa} or return $column_info;

    my %info = column_info_from_type($type);

    return merge( $column_info, \%info );
}

1;

=head1 SEE ALSO

L<Types::SQL>

L<Types::Standard>

=cut
