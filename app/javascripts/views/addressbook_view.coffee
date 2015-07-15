Radium.AddressbookView = Ember.View.extend
  actions:
    showAddCompany: ->
      @$('.new-company').slideToggle('medium', ->
        Ember.$('.new-company input[type=text]').focus()
      )

  layoutName: 'layouts/single_column'

  readAvailableHeight: Ember.on 'didInsertElement', ->
    @set 'controller.availableHeight', @$('#addressbook').height()
    $(window).on 'resize.AddressbookView', => @readAvailableHeight()

  teardownWindowResizeListener: Ember.on 'willDestroyElement', ->
    $(window).off 'resize.AddressbookView'

  classNames: ['addressbook-full-width']
