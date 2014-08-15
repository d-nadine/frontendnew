Radium.AddressbookView = Ember.View.extend
  actions:
    showAddCompany: ->
      @get('controller').send 'setupNewCompany'
      @$('.address-book-controls').slideUp('medium', =>
        @$('.new-company').slideDown('medium', =>
          Ember.$('.new-company input[type=text]').focus()
        )
      )


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
