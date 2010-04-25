CREATE TABLE `shoppingProduct` (
	`id` char(22) binary not null,
	`title` varchar(255) not null,
    `categoryId` char(22) not null,
    `barcode` int(13) null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20) not null,
	primary key (id),
    key shoppingProduct (title)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `shoppingCategory` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (id),
    key shoppingCategoryTitle (title)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `shoppingStore` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (id),
    key shoppingStoreTitle (title)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `shoppingStoreArea` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `ownerId` char(22) not null,
    `shoppingStoreId` char(22) not null,
    `dateAdded` bigint(20) not null,
    `rank` int(3),
    primary key (id),
    key shoppingStoreAreaTitle (title)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `shoppingList` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `dateAdded` bigint(20) not null,
    `dateDue` bigint(20) null,
    `defaultSort` varchar(255) null,
    `completed` smallint(1) default 0,
    `templateId` char(22)
    primary key (id),
    key shoppingListTitle (title)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `shoppingListProduct` (
    `id` char(22) binary not null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20) not null,
    `shoppingListId` char(22) not null,
    `shoppingProductId` char(22) not null,
    `shoppingStoreId` char(22) null,
    `quantity` int(3) not null default 1,
    primary key (id),
) ENGINE=MyISAM DEFAULT CHARSET=utf8;