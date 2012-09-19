view = null

# loading too much data doesn't really matter for this file,
# but fixtures can't load their dependencies yet, so it's
# easier to just load it all at once
app '/'
Fixtures.loadAll(now: true)
fakeController = Ember.Object.create
  pushItem: ->

module "Feed items",
  teardown: ->
    Ember.run ->
      if view && view.remove
        view.remove()
    view = null

test 'headerContext displays year if year is other than current', ->
  meeting = F.meetings('default')

  Ember.run ->
    view = Radium.TodoFormView.create(selection: meeting, controller: fakeController)
    view.append()

  view.set 'finishBy', '2013-01-01'

  equal view.get('headerContext'), 'Assign a Todo to “Product discussion” for Tuesday, 1/1/2013', ''


test 'headerContext displays proper data', ->
  meeting = F.meetings('default')

  Ember.run ->
    view = Radium.TodoFormView.create(selection: meeting, controller: fakeController)
    view.append()

  view.set 'finishBy', '2012-10-10'

  equal view.get('headerContext'), 'Assign a Todo to “Product discussion” for Wednesday, 10/10', ''

test 'submitting form sets proper data and reference on todo', ->
  meeting = F.meetings('default')

  Ember.run ->
    view = Radium.TodoFormView.create(selection: meeting, controller: fakeController)
    view.append()

  view.set 'descriptionField.value', 'Get notes for a meeting'
  view.set 'finishBy', '2012-10-10'

  view.submitForm()

  # Form waits to close before submitting, maybe it could be disabled for tests
  wait 250, ->
    todo = Radium.store.findAll(Radium.Todo).find (t) -> t.get('description') == 'Get notes for a meeting'

    ok todo, 'todo was not created'

    equal todo.get('reference'), meeting, ''
    equal todo.get('finishBy').toFormattedString('%Y-%m-%d'), '2012-10-10', ''
    equal todo.get('user'), Radium.get('router.meController.user'), ''
