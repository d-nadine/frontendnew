Radium.ContactSidebarView = Radium.FixedSidebarView.extend Radium.UploadingMixin,
  classNames: ['sidebar-panel-bordered']

  showExtraContactDetail: ->
    @$('.additional-detail').slideToggle('medium')
    @$('#existingToggle').toggleClass('icon-arrow-up icon-arrow-down')
