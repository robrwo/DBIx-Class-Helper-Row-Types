#!perl

use strict;
use warnings;

use Test::Most;

use lib 't/lib';

use Test::Schema;

my $dsn    = "dbi:SQLite::memory:";
my $schema = Test::Schema->deploy_or_connect($dsn);

ok my $rs = $schema->resultset('A'), 'resultset';

cmp_deeply $rs->result_source->column_info('id'),
  {
    data_type         => 'serial',
    is_auto_increment => 1,
    is_numeric        => 1,
    isa               => isa('Type::Tiny'),
  },
  'id';

cmp_deeply $rs->result_source->column_info('serial_number'), {
    data_type  => 'varchar',
    size       => 32,
    is_numeric => 1,                   # overridden
    isa        => isa('Type::Tiny'),
  },
  'serial_number';

done_testing;
