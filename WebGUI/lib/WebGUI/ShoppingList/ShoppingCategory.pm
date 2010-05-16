package WebGUI::ShoppingList::ShoppingCategory;

$VERSION = "1.0.0";

#-------------------------------------------------------------------
# Rory Zweistra 2010
#-------------------------------------------------------------------
# http://www.ryuu.nl                                   rory@ryuu.nl
#-------------------------------------------------------------------

use strict;
use Data::Dumper;
use WebGUI::ShoppingList::ShoppingCore;

#-------------------------------------------------------------------

=head2 addNewProduct ( )

Method to save a new product or update a existing one based on ownerId to the database.

=cut

sub saveCategory {
	my $self		= shift;
	my $core		= WebGUI::ShoppingList::ShoppingCore->new( $self->session );
	my $var			= $core->getDefaultSaveData;
	my $fullSet		= $self->session->form->paramsHashRef;
	my $skippedSet	= $core->skipStandardFormVars( $fullSet );
	my $params		= ( $var, $skippedSet );

	foreach my $param ( keys %{ $params } ) {
		$var->{ $param } = $newParams->{ $param };
	}

	my $updateId	= $self->updateDb( $var );

	return $updateId;
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
    return $self->{_session};
}

#-------------------------------------------------------------------

sub updateDb {
	my $self	= shift;
	my $data	= shift || undef;
	my $update	= $self->session->db->setRow( 'ShoppingProducts', 'id', $data );

	return $update;
}

1;