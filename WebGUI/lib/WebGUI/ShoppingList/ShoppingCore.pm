package WebGUI::ShoppingList::ShoppingCore;

$VERSION = "1.0.0";

#-------------------------------------------------------------------
# Rory Zweistra 2010
#-------------------------------------------------------------------
# http://www.oqapi.nl                                  rory@oqapi.nl
#-------------------------------------------------------------------

use strict;
use Data::Dumper;

#-------------------------------------------------------------------

=head2 getDefaultData ( )

Creates ShoppingList data that standardly should be saved to the database. This data set should be saved for any
kind of ShoppingList object.

=cut

sub getDefaultData {
    my $self	= shift;
    my $data	= {
		'id'		=> $self->session->generateId,
		'ownerId'	=> $self->session->user->userId,
		'dateAdded'	=> time,
	};

    return $data;
}

1;