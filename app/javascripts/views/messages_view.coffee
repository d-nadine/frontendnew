Radium.MessagesView = Radium.View.extend Radium.DarkBackgroundMixin,
  classNames: ['page-view']
  layoutName: 'layouts/sub_nav'

  setupCustom: ->
    @$('.todo-modal .mentions-input-box textarea').focus()

  _setup: Ember.on 'didInsertElement', ->
    @_super.apply this, arguments

    todoModal = $('.todo-modal')

    todoModal.modal('hide')

    todoModal.on 'shown', @setupCustom.bind(this)

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    $('.todo-modal').off 'shown'
