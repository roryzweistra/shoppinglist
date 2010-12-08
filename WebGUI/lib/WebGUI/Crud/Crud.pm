package WebGUI::Crud::ShoppingListProduct;

$VERSION = "1.0.1";

#------------------------------------------------------------------------------------------------------------------
# Rory Zweistra 2010
#------------------------------------------------------------------------------------------------------------------
# http://www.ryuu.nl  e: rory@ryuu.nl
#------------------------------------------------------------------------------------------------------------------

use strict;
use warnings;
use WebGUI::ShoppingList::ShoppingCore;

use base qw{ WebGUI::Crud };

#------------------------------------------------------------------------------------------------------------------

=head2 createUserClone

Creates a user specific clone of the record.

=cut

sub createUserClone {
	my $self	= shift;
	my $session	= shift;

	# Get the database handler used for this crud object.
	my $db		= WebGUI::ShoppingList::ShoppingCore->new( $session )->getDb;
}
#------------------------------------------------------------------------------------------------------------------

=head2 crud_definition

=cut

sub crud_definition {
	my $class		= shift;
    my $session		= shift;
    my $definition	= $class->SUPER::crud_definition( $session );

	# Table name & unique sequence column name.
	$definition->{ tableName	} = "ShoppingListProduct";
	$definition->{ tableKey		} = "shoppingListProductId";

	# Create the definition fields.
	$definition->{ properties }{ name			} = {
		fieldType		=> 'text',
        defaultValue    => 'Product name',
    };
    $definition->{ properties }{ } = {
        fieldType       => 'email',
        defaultValue    => undef,
    };

	return $definition;
}

1;