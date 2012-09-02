view = null

# loading too much data doesn't really matter for this file,
# but fixtures can't load their dependencies yet, so it's
# easier to just load it all at once
Fixtures.loadAll(now: true)
Radium.initialize()
fakeController = Ember.Object.create
  pushItem: ->

module "Feed items",
  teardown: ->
    Ember.run ->
      if view && view.remove
        view.remove()
    view = null

test 'headerContext displays proper data', ->
  meeting = F.meetings('default')

  Ember.run ->
    view = Radium.TodoFormView.create(selection: meeting, controller: fakeController)
    view.append()

  view.set 'finishBy', '2012-10-10'

  equal view.get('headerContext'), 'Assign a Todo to “Product discussion” for Wednesday, 10/10/2012', ''

test 'submiting form sets proper data and reference on todo', ->
  meeting = F.meetings('default')

  Ember.run ->
    view = Radium.TodoFormView.create(selection: meeting, controller: fakeController)
    view.append()

  view.set 'descriptionField.value', 'Get notes for a meeting'
  view.set 'finishBy', '2012-10-10'

  view.submitForm()

  todo = Radium.store.findAll(Radium.Todo).find (t) -> t.get('description') == 'Get notes for a meeting'

  ok todo, 'todo was not created'

  equal todo.get('reference'), meeting, ''
  equal todo.get('finishBy').toFormattedString('%Y-%m-%d'), '2012-10-10', ''
  equal todo.get('user'), Radium.get('router.meController.user'), ''
