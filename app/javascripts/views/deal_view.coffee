require 'mixins/views/sticky_banner_mixin'

Radium.DealView = Radium.View.extend Radium.StickyBannerMixin,
  classNames: ['page-view']
  layoutName: 'layouts/two_column'
  dealProgressBarWidth: (->
    status = @get('controller.status')
    statuses = @get('controller.statuses')
    index = statuses.indexOf(status) + 1
    width = (index / statuses.length) * 100
    "width: #{width}%"
  ).property('controller.status')