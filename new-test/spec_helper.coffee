minispade.require "boot"
Ember.testing = true
Ember.Test.adapter = Ember.Test.Adapter.create()
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
window.component = (type, options = {})->
  throw new Error("component:#{name} does not exist") unless type?
  component = type.create Ember.merge {container: Radium.__container__}, options
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
