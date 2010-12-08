package WebGUI::ShoppingList::ShoppingCategory;

$VERSION = "1.0.7";

#------------------------------------------------------------------------------------------------------------------
# Rory Zweistra 2010
#------------------------------------------------------------------------------------------------------------------
# http://www.ryuu.nl  e: rory@ryuu.nl
#------------------------------------------------------------------------------------------------------------------

use strict;
use warnings;
use Data::Dumper;
use WebGUI::Utility;
use WebGUI::ShoppingList::ShoppingCore;
use List::MoreUtils qw( uniq );

my $table		= 'ShoppingCategory';
my $primaryKey	= 'id';

#------------------------------------------------------------------------------------------------------------------

=head2 deleteCategory ( )

Method to delete a category from the database. Admins only.

=cut

sub deleteCategory {
	my $self		= shift;
	my $id			= shift || undef;

	return $self->session->unprivileged unless $self->session->user->isAdmin;

	my $core		= WebGUI::ShoppingList::ShoppingCore->new( $self->session );
	my $deleteId	= $core->deleteFromDb( $table, $primaryKey, $id );
	undef $core;

	return $deleteId;
}

#------------------------------------------------------------------------------------------------------------------

=head2 deletePersonalCategory ( )

Method to delete a category based on ownerId to the database.

=cut

sub deletePersonalCategory {
	my $self		= shift;
	my $id			= shift || undef;
	my $data		= $self->getPersonalCategories;
	my $match		= $data->{ $id };

	# TODO: Create error here if id not in hash

	my $core		= WebGUI::ShoppingList::ShoppingCore->new( $self->session );
	my $deleteId	= $core->deleteFromDb( $table, $primaryKey, $id );

	return $deleteId;
}

#------------------------------------------------------------------------------------------------------------------

=head2 getAllCategories ( )

Method to retrieve personal & all other categories from the database. If personal categories are defined only the
personal ones are returned. Returns a hashref.

=cut

sub getAllCategories {
	my $self			= shift;
	my $data			= $self->getCategories;
	my $personalData	= $self->getPersonalCategories;
	my $allData			= { %$data, %$personalData };

	return $data;
}

#------------------------------------------------------------------------------------------------------------------

=head2 getCategories ( )

Method to retrieve categories from the database. Returns a hashRef.

=cut

sub getCategories {
	my $self	= shift;
	my $data	= $self->session->db->buildHashRefOfHashrefs( "SELECT
			id,
			title
		FROM
			$table",
	);

	return $data;
}

#------------------------------------------------------------------------------------------------------------------

=head2 getPersonalCategories ( )

Method to retrieve per user personal categories from the database. Returns an ArrayRef.

=cut

sub getPersonalCategories {
	my $self	= shift;
	my $data	= $self->session->db->buildHashRefOfHashRefs( "SELECT
			originalId,
			title
		FROM
			$table
		WHERE
			ownerId = ?",
		[ $self->session->userId ],
	);

	return $data;
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

=head2 saveCategory ( )

Method to save a new category or update a existing one based on ownerId to the database.

=cut

sub saveCategory {
	my $self		= shift;
	my $core		= WebGUI::ShoppingList::ShoppingCore->new( $self->session );
	my $fullSet		= $self->session->form->paramsHashRef;
	my $defaultVar	= $core->getDefaultSaveData;
	my $skippedSet	= $core->skipStandardFormVars( $fullSet );
	my $params		= { %$defaultVar, %$skippedSet };
	my $updateId	= $core->updateDb( $table, $primaryKey, $params );

	return $updateId;
}

#------------------------------------------------------------------------------------------------------------------

sub session {
    my $self = shift;
    return $self->{_session};
}

#------------------------------------------------------------------------------------------------------------------

sub updateCategory {
	my $self		= shift;
	my $id			= $self->session->form->process( 'categoryId'	) || undef;
	my $title		= $self->session->form->process( 'title'		) || undef;

	return unless $title;

	my @categoryIds	= $self->session->db->buildArray( "SELECT
			id
		FROM
			ShoppingCategory,
			ShoppingCategoryPersonal"
	);

	# Remove duplicate id's from the array.
	@categoryIds	= uniq ( @categoryIds );
	my $data;

	# Check to see if the id exists in the db.
	if ( isIn ( $id, @categoryIds ) ) {

		# Check to see if the id exists in the personal table.
		my $personalExists = $self->session->db->quickScalar( "SELECT
				id
			FROM
				ShoppingCategoryPersonal
			WHERE
				id = ?,
			[
				$id
			]"
		);

		# If the id exists in the personal table, set the data to update the personal table.
		if ( $personalExists == $id ) {
			$data->{ id		} = $id;
			$data->{ title	} = $title;
		}
		else {

			# If the id only exists in the category table and the user is an admin, set the data to update the
			# categroy table.
			if ( $self->session->user->isAdmin ) {
				$data->{ id		} = $id;
				$data->{ title	} = $title;
			}
			# If the user is not an admin, create a personal category entry.
			else {
				$data->{ id			} = $self->session->id->generate;
				$data->{ originalId	} = $data->{ id };
				$data->{ title		} = $title;

				# Set the personal category db table as the db table to be updated.
				$table = 'ShoppingPersonalCategory';
			}

		}

		# Update the table.
		my $core	= WebGUI::ShoppingCore::new->( $self->session );
		$id			= $core->updateDb( $table, $primaryKey, $data );

	}

	return $id;
}

#------------------------------------------------------------------------------------------------------------------

=head2 www_deleteCategory ( )

Web method to delete personal category. Only Admins are allowed to do this.

=cut

sub www_deleteCategory {
	my $self	= shift;

	return $self->session->unprivilleged unless $self->session->user->isAdmin;

	my $id		= $self->session->form->process( 'categoryId' );
	my $delete	= $self->deleteCategory( $id );

	# TODO: Determine what to do with the returning value
	return $delete;

}

#------------------------------------------------------------------------------------------------------------------

=head2 www_deletePersonalCategory ( )

Web method to deleta a personal category.

=cut

sub www_deletePersonalCategory {
	my $self	= shift;
	my $id		= $self->session->form->process( 'categoryId' );
	my $delete	= $self->deletePersonalCategory( $id );

	# TODO: Determine what to do with the returning value
	return $delete;

}

#------------------------------------------------------------------------------------------------------------------

=head2 www_getAllCategories ( )

Web method to retrieve a selectlist containing all the categories.

=cut

sub www_getAllCategories {
	my $self	= shift;
	my $options	= $self->getAllCategories;
	my $core	= WebGUI::ShoppingList::ShoppingCore->( $self->session );
	my $var;

	# Create a template var containing the select box.
	$var->{ allCategoriesSelectBox } = $core->createSelectBox( $options, 'getAllCategories');

	# TODO: Create Shopping::Admin for controlling templates from Admin Console. See Shop::Admin for what I mean.
	return $var;

}

#------------------------------------------------------------------------------------------------------------------

=head2 www_getCategories ( )

Web method to retrieve a selectlist containing all the default categories.

=cut

sub www_getCategories {
	my $self	= shift;
	my $options	= $self->getCategories;
	my $core	= WebGUI::ShoppingList::ShoppingCore->( $self->session );
	my $var;

	# Create a template var containing the select box.
	$var->{ defaultCategoriesSelectBox } = $core->createSelectBox( $options, 'getCategories' );

	# TODO: Create Shopping::Admin for controlling templates from Admin Console. See Shop::Admin for what I mean.
	return $var;

}

#------------------------------------------------------------------------------------------------------------------

=head2 www_getPersonalCategories ( )

Web method to retrieve a selectlist containing all the personal categories.

=cut

sub www_getPersonalCategories {
	my $self	= shift;
	my $options	= $self->getPersonalCategories;
	my $core	= WebGUI::ShoppingList::ShoppingCore->( $self->session );
	my $var;

	# Create a template var containing the select box.
	$var->{ personalCategoriesSelectBox } = $core->createSelectBox( $options, 'getPersonalCategories');

	# TODO: Create Shopping::Admin for controlling templates from Admin Console. See Shop::Admin for what I mean.
	return $var;

}

#------------------------------------------------------------------------------------------------------------------

=head2 www_updatePersonalCategory ( )

Web method to add or update a personal category.

=cut

sub www_updateCategory {
	my $self	= shift;
	my $update	= $self->updateCategory;

	return $update;
}

1;