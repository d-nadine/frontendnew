require 'mixins/views/sticky_banner_mixin'

Radium.DealView = Radium.View.extend Radium.StickyBannerMixin,
  classNames: ['page-view']
  layoutName: 'layouts/two_column'

  didInsertElement: ->
    @_super.apply this, arguments
    @notifyPropertyChange('dealProgressBarWidth')

  dealProgressBarWidth: (->
    return 0 unless Ember.$('.deal-progress').length
    start = Ember.$('.deal-progress > a:first').offset().left
    finish = $(".deal-progress  a.#{@get('controller.status').dasherize()}").offset().left
    width = finish - start
    width = width + 20 if width > 0
    "width: #{width}px"
  ).property('controller.status')
