create table `shoppingProduct` (
	`id` char(22) binary not null,
	`title` varchar(255) not null,
    `categoryId` char(22) not null,
    `barcode` int(13) null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20) not null,
	primary key (`id`),
    key shoppingProduct (`title`)
)

create table `shoppingCategory` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (`id`),
    key shoppingCategoryTitle (`title`)
)

create table `shoppingStore` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20),
    primary key (`id`),
    key shoppingStoreTitle (`title`)
)

create table `shoppingStoreArea` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `ownerId` char(22) not null,
    `shoppingStoreId` char(22) not null,
    `dateAdded` bigint(20) not null,
    `rank` int(3),
    primary key (`id`),
    key shoppingStoreAreaTitle (`title`)
)

create table `shoppingList` (
    `id` char(22) binary not null,
    `title` varchar(255) not null,
    `dateAdded` bigint(20) not null,
    `dateDue` bigint(20) null,
    `defaultSort` varchar(255) null,
    `completed` smallint(1) default 0,
    `templateId` char(22)
    primary key (`id`),
    key shoppingListTitle (`title`)
)

create table `shoppingListProduct` (
    `id` char(22) binary not null,
    `ownerId` char(22) not null,
    `dateAdded` bigint(20) not null,
    `shoppingListId` char(22) not null,
    `shoppingProductId` char(22) not null,
    `shoppingStoreId` char(22) null,
    `quantity` int(3) not null default 1,
    primary key (`id`),
)