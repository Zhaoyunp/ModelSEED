package ModelSEED::DB::Roleset;


use strict;
use Data::UUID;

use base qw(ModelSEED::DB::DB::Object::AutoBase2);

__PACKAGE__->meta->setup(
    table   => 'rolesets',

    columns => [
        uuid       => { type => 'character', length => 36, not_null => 1 },
        modDate    => { type => 'datetime' },
        locked     => { type => 'integer' },
        public     => { type => 'integer' },
        id         => { type => 'varchar', length => 32 },
        name       => { type => 'varchar', length => 255 },
        searchname => { type => 'varchar', length => 255 },
        class      => { type => 'varchar', length => 255 },
        subclass   => { type => 'varchar', length => 255 },
        type       => { type => 'varchar', length => 32 },
    ],

    primary_key_columns => [ 'uuid' ],

    relationships => [
        children => {
            map_class => 'ModelSEED::DB::RolesetParent',
            map_from  => 'parent',
            map_to    => 'child',
            type      => 'many to many',
        },

        parents => {
            map_class => 'ModelSEED::DB::RolesetParent',
            map_from  => 'child',
            map_to    => 'parent',
            type      => 'many to many',
        },

        roles => {
            map_class => 'ModelSEED::DB::RolesetRole',
            map_from  => 'roleset',
            map_to    => 'role',
            type      => 'many to many',
        },
    ],
);



__PACKAGE__->meta->column('uuid')->add_trigger(
    deflate => sub {
        my $uuid = $_[0]->uuid;
        if(ref($uuid) && ref($uuid) eq 'Data::UUID') {
            return $uuid->to_string();
        } elsif($uuid) {
            return $uuid;
        } else {
            return Data::UUID->new()->create_str();
        }   
});


1;

