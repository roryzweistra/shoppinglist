package WebGUI::Macro::AlbumFiles;

use strict;
use warnings;
use WebGUI::Asset;
use WebGUI::Asset::Template;

#-------------------------------------------------------------------
sub process {
	my $session     = shift;
	my $parentId    = shift;
	my $templateId  = shift;
    my @varLoop;

    my $parent      = WebGUI::Asset->newByDynamicClass( $session, $parentId );

    return 'parent could not be instanciated, please check the Id' unless $parent;

    my $images      = $parent->getLineage( [ 'descendants' ], {
        includeOnlyClasses  	=> [ 'WebGUI::Asset::File::GalleryFile::Photo' ],
        returnObjects       	=> 1,
        statesToInclude     	=> [ 'published'    ],
        statusToInclude    		=> [ 'approved'     ],
        invertTree				=> 1,
    });

    foreach my $image ( @$images ) {
        my $vars = $image->getTemplateVars;
        push @varLoop, $vars;
    }

    my $var->{ 'imageLoop' } = \@varLoop;

    my $template = WebGUI::Asset::Template->new( $session, $templateId );

    return 'template could not be instanciated' unless $template;

	return $template->process( $var );
}

1;