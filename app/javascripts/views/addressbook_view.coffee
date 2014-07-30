Radium.AddressbookView = Ember.View.extend
  layoutName: 'layouts/single_column'

  readAvailableHeight: (->
    @set 'controller.availableHeight', @$('#addressbook').height()
  ).on 'didInsertElement'

  setupWindowResizeListener: (->
    $(window).on 'resize.AddressbookView', => @readAvailableHeight()
  ).on 'didInsertElement'

  teardownWindowResizeListener: (->
    $(window).off 'resize.AddressbookView'
  ).on 'willDestroyElement'
