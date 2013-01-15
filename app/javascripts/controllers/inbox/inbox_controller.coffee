Radium.InboxController = Em.ArrayController.extend
  selectedMail: ( ->
    Em.ArrayProxy.create Ember.FilterableMixin,
      context: this
      contentBinding: 'context.content'
      filterProperties: ['isSelected']
  ).property('content')

  previousSelectedMailCount: -1

  selectedMailDidChange: ( ->
    previous = @get('previousSelectedMailCount')
    selectedMailLength = @get('selectedMail.length')

    if(previous == 0 && selectedMailLength == 1)
      Radium.get('router').send 'emailBulkAction'

    if(previous > 0 && selectedMailLength == 0)
      @set('previousSelectedMailCount', 0)
      Radium.get('router').send 'showInbox'
    else
      @set('previousSelectedMailCount', previous + 1)
  ).observes('selectedMail.length')

  createTodo: (data, email) ->
    todo = Radium.Todo.createRecord(data)
    todo.set('reference', email)
    todo.store.commit()

    # TODO: Radium.get('router.activeFeedController').pushHitem todo
  deleteEmail: (email) ->
    email.set('isSelected', false)
    # FIXME: ember-data association errors, fake for now
    # store = @get('store')

    # email.deleteRecord()
    # store.commit()

    @removeObject(email)
    Radium.Utils.notify "email deleted."

  deleteEmails: ->
    selected = @get('content').filter (email) -> email.get('isSelected')

    return if selected.get('count') == 0

    count = selected.get('length')
    # FIXME: ember-data association errors, fake for now
    # @get('selectedMail').toArray().forEach (email) ->
    #   email.deleteRecord()
    # @get('store').commit()
    selected.forEach (email) -> email.set('isSelected', false)

    @removeObjects(selected)

    Radium.Utils.notify "#{count} emails deleted."
