package WebGUI::Macro::RecentPosts;

use strict;
use warnings;
use WebGUI::Asset;
use WebGUI::Asset::Template;
use Data::Dumper;

#------------------------------------------------------------------------------------------------------------------

=head1 NAME

Package WebGUI::Macro::RecentPosts

=head1 DESCRIPTION

This macro tries to get an x number of threads that are descendants of a specified parent.
It returns a loop (<tmpl_loop postLoop>) containting tmpl_vars for each of the retrieved threads.
tmpl_vars that can be used inside the loop are:

content, newWindow, extraHeadTagsPacked, threadId, url, hasRated, isHidden, groupIdEdit, delete.url,
inheritUrlFromParent, username, className, threadRating, userDefined1, title, storageId, url.raw, skipNotification,
userDefined5, lastPostDate, hideProfileUrl, views, reply.url, stateChanged, revisionDate, subscriptionGroupId,
userProfile.url, originalEmail, attachment_loop, encryptPage, userId, isSystem, revisedBy, karma, userDefined2,
creationDate, lastPostId, user.isPoster, rating.value, lastExportedAs, createdBy, reply.withquote.url,
userDefined3, replies, state, edit.url, synopsis, extraHeadTags, ownerUserId, assetId, avatar.url, isPrototype,
title.short, dateUpdated.human, rate.url.thumbsUp, isLocked, lineage, stateChangedBy, lastModified, isSticky,
groupIdView, assetSize, menuTitle, status, user.canEdit, rating, isLockedBy, karmaScale, isPackage,
usePackedHeadTags, dateSubmitted.human, contentType, userDefined4, tagId, isExportable, rate.url.thumbsDown,
parentId, karmaRank

=head2 process ( parentId,templateId, [ limit, invert ] )

process takes 2 required parameters and 1 optional parameter.

=head3 parentId

The assetId of the parent where you want to start searching from

=head3 templateId

The assetId of the template which you use to parse the tmpl_vars

=head3 limit

The amount of threads to be returned. Defaults to 3.

=head3 invert

yes/no. Determines wether the tree should be returned inverted. Defaults to no.

=cut

#-------------------------------------------------------------------
sub process {
	my $session     = shift;
	my $parentId    = shift;
	my $templateId  = shift;
	my $limit       = shift || 3;
	my $invert		= lc( shift );
	$invert			= ( $invert eq 'yes' ) ? 1 : 0;
    my @varLoop;

	# Determine the parent. This can be anything From a Page to a CS.
    my $parent      = WebGUI::Asset->newByDynamicClass( $session, $parentId );

    return 'parent could not be instanciated, please check the Id' unless $parent;

    my $posts		= $parent->getLineage( [ 'descendants' ], {
        isa					=> 'WebGUI::Asset::Post',
        limit               => $limit,
        returnObjects       => 1,
        statesToInclude     => [ 'published'    ],
        statusToInclude     => [ 'approved'     ],
		invertTree			=> $invert,
    });

    foreach my $post ( @$posts ) {
        my $vars = $post->getTemplateVars;
        push @varLoop, $vars;
    }

    my $var->{ 'postLoop' } = \@varLoop;

    my $template = WebGUI::Asset::Template->new( $session, $templateId );

    return 'template could not be instanciated' unless $template;

	return $template->process( $var );
}

1;