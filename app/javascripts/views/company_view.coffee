require 'mixins/views/sticky_banner_mixin'

Radium.CompanyView = Radium.View.extend Radium.StickyBannerMixin,
  classNames: ['page-view']
  layoutName: "layouts/two_column"