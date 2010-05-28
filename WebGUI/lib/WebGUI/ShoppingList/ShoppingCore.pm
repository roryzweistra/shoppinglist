package WebGUI::ShoppingList::ShoppingCore;

$VERSION = "1.0.0";

#-------------------------------------------------------------------
# Rory Zweistra 2010
#-------------------------------------------------------------------
# http://www.ryuu.nl                                    rory@ryuu.nl
#-------------------------------------------------------------------

use strict;
use Data::Dumper;

#-------------------------------------------------------------------

=head2 getDefaultData ( )

Creates ShoppingList data that standardly should be saved to the database. This data set should be saved for any
kind of ShoppingList object.

=cut

sub getDefaultSaveData {
    my $self	= shift;
    my $data	= {
		'id'		=> $self->session->generateId,
		'ownerId'	=> $self->session->user->userId,
		'dateAdded'	=> time,
	};

    return $data;
}

#-------------------------------------------------------------------

=head2 skipStandardFormVars ( )

This method makes sure the standard WebGUI form vars ( csfr token, submit, func ) don't get included in the
data set that should be saved to the database.

=cut

sub skipStandardFormVars {
    my $self		= shift;
	my $data		= shift;
	my @varsToSkip	= ( 'func', 'submit', 'webguiCsrfToken' );

	$data = delete $data->{ @varsToSkip };

    return $data;
}

#-------------------------------------------------------------------

sub updateDb {
	my $self		= shift;
	my $table		= shift || undef;
	my $primaryKey	= shift || undef;
	my $data		= shift || undef;
	my $update		= $self->session->db->setRow( $table, $primaryKey, $data );

	return $update;
}

1;