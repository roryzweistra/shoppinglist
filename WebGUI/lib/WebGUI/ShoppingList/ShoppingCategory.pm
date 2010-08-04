package WebGUI::ShoppingList::ShoppingCategory;

$VERSION = "1.0.6";

#-----------------------------------------------------------------------------------------------------------------
# Rory Zweistra 2010
#------------------------------------------------------------------------------------------------------------------
# http://www.ryuu.nl  e: rory@ryuu.nl
#------------------------------------------------------------------------------------------------------------------

use strict;
use Data::Dumper;
use WebGUI::ShoppingList::ShoppingCore;

my $table		= 'ShoppingCategory';
my $primaryKey	= 'id';

#------------------------------------------------------------------------------------------------------------------

=head2 getAllCategories ( )

Method to retrieve personal & all other categories from the database. If personal categories are defined only the
personal ones are returned.

=cut

sub getAllCategories {
	my $self			= shift;
	my $data			= $self->getCategories;
	my $personalData	= $self->getPersonalCategories;
	my @ids;

	# Create a list of all id's in the personal data
	foreach my $id ( keys %$personalData ) {
		push @ids, $id;
	}

	# Check if a personal category exists and replace original title with personal title
	foreach my $categoryId ( @ids ) {
		if exists $data->{ $categoryId } {
			$data->{ $categoryId }->{ title } = $personalData->{ $categoryId }->{ title };
		}
	}

	return $data;
}

#------------------------------------------------------------------------------------------------------------------

=head2 getCategories ( )

Method to retrieve categories from the database.

=cut

sub getCategories {
	my $self	= shift;
	my $data	= $self->session->db->buildHashrefOfHashRefs( "SELECT
			id,
			title
		FROM
			" . $self->session->db->quote( $table ),
		[],
		'id'
		);

	return $data;
}

#------------------------------------------------------------------------------------------------------------------

=head2 getPersonalCategories ( )

Method to retrieve per user personal categories from the database.

=cut

sub getPersonalCategories {
	my $self	= shift;
	my $data	= $self->session->db->buildHashrefOfHashrefs( "SELECT
			originalId,
			title
		FROM
			" . $self->session->db->quote( $table ) . "
		WHERE
			ownerId = ?",
		[ $self->session->userId ],
		'originalId'
	);

	return $data;
}

#------------------------------------------------------------------------------------------------------------------

=head2 saveCategory ( )

Method to save a new category or update a existing one based on ownerId to the database.

=cut

sub saveCategory {
	my $self		= shift;
	my $core		= WebGUI::ShoppingList::ShoppingCore->new( $self->session );
	my $fullSet		= $self->session->form->paramsHashRef;
	my $defaultVar	= $core->getDefaultSaveData;
	my $skippedSet	= $core->skipStandardFormVars( $fullSet );
	my $params		= ( $defaultVar, $skippedSet );
	my $updateId	= $core->updateDb( $table, $primaryKey, $params );

	return $updateId;
}

#------------------------------------------------------------------------------------------------------------------

sub new {
    my $class        = shift;
    my $session      = shift;
    my $properties   = {
        _session    => $session,
    };

    bless $properties, $class;
}

#------------------------------------------------------------------------------------------------------------------

sub session {
    my $self = shift;
    return $self->{_session};
}

1;