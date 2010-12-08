package WebGUI::ShoppingList::ShoppingCore;

$VERSION = "1.0.0";

#------------------------------------------------------------------------------------------------------------------
# Rory Zweistra 2010
#------------------------------------------------------------------------------------------------------------------
# http://www.ryuu.nl  e: rory@ryuu.nl
#------------------------------------------------------------------------------------------------------------------

use strict;
use Data::Dumper;

#------------------------------------------------------------------------------------------------------------------

=head2 createSelectBox ( )

Returns a WebGUI::Form::SelectBox containing the data provided. Takes a hashref containing all the options as a
parameter

=cut

sub createSelectBox {
    my $self	= shift;
    my $options	= shift || undef;
	my $name	= shift || undef;
	my $id		= shift || $name || undef;
	my $extras	= shift || undef;

	my $selectbox	= WebGUI::Form::SelectBox( $self->session, {
		name	=> $name,
		id		=> $id,
		options	=> $options,
		extras	=> $extras,
	});

    return $selectbox;
}

#------------------------------------------------------------------------------------------------------------------

sub getDb {
	my $self	= shift;
	my $session	= shift;
	my $dbName	= 'shoppingList';

	my $databaseLinkId	= $session->db->quickScalar( "SELECT
			databaseLinkId
		FROM
			databaseLink
		WHERE
			title = ?
		LIMIT 1",
		[
			$dbName
		]
	);

	my $dbLink			= WebGUI::DatabaseLink->new( $session, $databaseLinkId );

	return $dbLink;
}

#------------------------------------------------------------------------------------------------------------------

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
sub new {
	my $class        = shift;
	my $session      = shift;
	my $properties   = {
		_session    => $session,
	};

	bless $properties, $class;
}

#-------------------------------------------------------------------
sub session {
	my $self = shift;

	return $self->{ _session };
}

#------------------------------------------------------------------------------------------------------------------

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

1;