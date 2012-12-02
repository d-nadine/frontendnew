# Radium

## Feed design

Feed is divided into feed sections which represent specific days. By default
feed is just a list of `Radium.FeedSection` models, which contain feed items,
which are implemented with `Radium.ExtendedRecordArray`. Extended record array
is really similar to regular record array, with the small difference in data that
it can held - instead of keeping client ids internally, it keeps pairs of
record type and client id. This allows to keep multiple type of records in such
array.

If there is more items of the same type, they are collected into clusters. Clustering
is added with `Radium.ClusteredRecordArray` mixin, which adds 2 attributes
to an array: `clusters` and `unclustered`. You can still iterate through the array
with `section.get('items').forEach`, but if you want to use clusters, you have
those additional attributes to deal with it.

The most important view for displaying feed is `Radium.FeedSectionsListView`. It
displays individual sections and manages things like scroll adjustments (for example
if items are added on top of the feed, it will adjust `scrollTop` value to make
scrolling smooth and avoid jumps). It also manages inserting "gap views". If user
filters feed and additional feed sections are loaded, we show the information that
additional feed items are loaded, but they're filtered.

Feed sections number is by default limited to whatever is set in `controller.itemsLimit`,
which by default is 30. This is done to not make app slow if user scrolls a lot. At
some point in time, the limit could be changed to something bigger, but without
optimization in the app or optimizations in ember, it's safe value to not make
site really slow.

Individual section is just a list of items handled by `Radium.FeedItemsListView`. The
only not so usual thing is that it uses container (`Radium.FeedItemContainerView`) as
`itemViewClass`. This is needed, because feed item may be any of several types of items,
like Todo, Meeting etc

## Filtering

Filtering is done with `FilteredCollectionMixin`, which uses `Filterable` mixin underneath
and filters items based on a setting in controller.

## Calendar feed

I designed calendar feed to behave just like regular feed, but with specific filter
displayed by default and `disableClusters` set by default.

## Ranges

Users can group sections in to ranges - you can display feed in daily, weekly and
monthly chunks. This is implemented as an array which is basically proxy over several
feed sections. So for example if you want to display weekly range, it will group
7 feed sections and will combine all the items from those 7 sections into one
collection. Class that's used for this is `Radium.GroupedFeedSection`. Although it's
a model, I didn't assume that it will be fetched from server - it's just because
I wanted to cache created records easier. I'm not sure if this is a good idea at the
moment - depending on future direction that application will be going, maybe
it will be better to change the impplementation to use ad-hoc class that will be
destroyed when not used. This may be better approach if for example grouped feed
sections start taking too much memory.

## Notifications center

Notifications center is pretty straightforward thing - it just displays list of
active notifications and takes you to a view of given item when notification for it
was clicked.
