Radium.AddressbookView = Ember.View.extend
  layoutName: 'layouts/single_column'

  readAvailableHeight: (->
    console.log 'hello', @$('#addressbook').height(), @get('controller.constructor')

    @set 'controller.availableHeight', @$('#addressbook').height()
  ).on 'didInsertElement'

  setupWindowResizeListener: (->
    $(window).on 'resize.AddressbookView', => @readAvailableHeight()
  ).on 'didInsertElement'

  teardownWindowResizeListener: (->
    $(window).off 'resize.AddressbookView'
  ).on 'willDestroyElement'
