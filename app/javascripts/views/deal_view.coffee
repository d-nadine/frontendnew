require 'mixins/views/sticky_banner_mixin'

Radium.DealView = Radium.View.extend Radium.StickyBannerMixin,
  classNames: ['page-view']
  layoutName: 'layouts/two_column',
  statusString: (->
    "status-" + @get('controller.status').toLowerCase().dasherize()
  ).property('controller.status')