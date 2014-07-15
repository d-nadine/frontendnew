minispade.require "boot"
Ember.testing = true
Radium.setupForTesting()
Radium.injectTestHelpers()
Radium.set('rootElement', 'body')


window.require = (module_id)->
  console.log module_id

window.beforeEach = ((original)->
  return (fn)->
    original ->
      Ember.run => fn.call(this)
)(beforeEach)

window.afterEach = ((original)->
  return (fn)->
    original ->
      Ember.run => fn.call(this)
)(afterEach)

components = []
window.component = (name, options = {})->
  component = Radium.__container__.lookup("component:#{name}")
  throw new Error("component:#{name} does not exist") unless component
  component.setProperties options
  component.append()
  components.push component
  return component

afterEach ->
  components.forEach (component)-> component.destroy()

beforeEach ->
  @sandbox = sinon.sandbox.create()
afterEach ->
  @sandbox.restore()

beforeEach ->
  @store = Radium.__container__.lookup 'store:main'
