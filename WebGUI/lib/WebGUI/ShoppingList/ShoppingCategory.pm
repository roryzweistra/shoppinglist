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

my $table		= 'ShoppingCategory';
my $primaryKey	= 'id';

#-------------------------------------------------------------------

=head2 saveCategory ( )

Method to save a new category or update a existing one based on ownerId to the database.

=cut

sub saveCategory {
	my $self		= shift;
	my $core		= WebGUI::ShoppingList::ShoppingCore->new( $self->session );
	my $defaultVar	= $core->getDefaultSaveData;
	my $fullSet		= $self->session->form->paramsHashRef;
	my $skippedSet	= $core->skipStandardFormVars( $fullSet );
	my $params		= delete %${ ( $defaultVar, $skippedSet ) };
	my $updateId	= $core->updateDb( $table, $primaryKey, $var );

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

1;