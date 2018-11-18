package Test::Schema::Result::A;

use base qw/DBIx::Class::Core/;

use Types::SQL -types;

__PACKAGE__->load_components(qw/ Helper::Row::Types /);

__PACKAGE__->table('a');

__PACKAGE__->add_columns(

    id => Serial,

    name => {},

    serial_number => {
        isa => Varchar [32], #
        is_numeric => 1,     # overridden
    },


);

__PACKAGE__->set_primary_key('id');

1;
