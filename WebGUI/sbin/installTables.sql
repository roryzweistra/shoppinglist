CREATE TABLE `ShoppingProducts` (
	`id` char(22) binary not null,
	`title` varchar(255) not null,
    `description` text null;
    `categoryId` char(22) not null,
    `barcode` int(13) null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20) not null,
	primary key (`id`),
    key `shoppingProduct` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingProductsPersonal` (
    `id` char(22) binary not null,
    `userId` char(22) not null,
    `originalId` char(22) binary not null,
    `title` varchar(255) null,
    `description` text null;
    `categoryId` char(22) null,
    `originalCategoryId` char(22) not null,
    primary key (`id`),
    key `shoppingProductPersonal` (`title`)
) ENGINE-MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingCategory` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `description` text null;
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (`id`),
    key `shoppingCategoryTitle` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingCategoryPersonal` (
    `id` char(22) binary not null,
    `originalId` char(22) binary not null,
    `title` varchar(255) not null,
    `description` text null;
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (`id`),
    key `shoppingCategoryTitlePersonal` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingStore` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `description` text null;
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (`id`),
    key `shoppingStoreTitle` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingStorePersonal` (
    `id` char(22) binary not null,
    `originalId` char(22) binary not null,
    `title` varchar(255) not null,
    `description` text null;
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (`id`),
    key `shoppingStoreTitle` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingStoreArea` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `ownerId` char(22) not null,
    `shoppingStoreId` char(22) not null,
    `dateAdded` bigint(20) not null,
    `rank` int(3),
    primary key (`id`),
    key `shoppingStoreAreaTitle` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingList` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `dateAdded` bigint(20) not null,
    `dateDue` bigint(20) null,
    `defaultSort` varchar(255) null,
    `completed` int(1) default 0,
    `ownerId` char(22) not null,
    `templateId` char(22),
    primary key (`id`),
    key `shoppingListTitle` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `ShoppingListProduct` (
    `id` char(22) binary not null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20) not null,
    `shoppingListId` char(22) not null,
    `shoppingProductId` char(22) not null,
    `shoppingStoreId` char(22) null,
    `quantity` int(3) not null default 1,
    primary key (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;