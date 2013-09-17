require 'mixins/views/sticky_banner_mixin'
require 'views/deal/deal_name_view'

Radium.DealView = Radium.View.extend Radium.StickyBannerMixin,
  classNames: ['page-view']
  layoutName: 'layouts/two_column'