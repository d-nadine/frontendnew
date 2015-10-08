Radium.AddressbookView = Ember.View.extend
  layoutName: 'layouts/single_column'

  readAvailableHeight: Ember.on 'didInsertElement', ->
    @set 'controller.availableHeight', @$('#addressbook').height()
    $(window).on 'resize.AddressbookView', => @readAvailableHeight()

  teardownWindowResizeListener: Ember.on 'willDestroyElement', ->
    $(window).off 'resize.AddressbookView'
