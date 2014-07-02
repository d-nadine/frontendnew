Ember.testing = true
# Radium.setupForTesting()
# Radium.injectTestHelpers()
# Radium.set('rootElement', 'body')


window.require = (module_id)->
  console.log module_id
  #document.write("<script src='#{}'")

window.beforeEach = ((original)->
  return (fn)->
    original ->
      Ember.run => fn.call(this)
)(beforeEach)

window.afterEach = ((original)->
  return (fn)->
    original ->
      Ember.run => fn.call(this)
)(after)

beforeEach ->
  Radium.advanceReadiness()
afterEach ->
  Radium.reset()

components = []
window.component = (name, options = {})->
  component = Radium.__container__.lookup("component:#{name}", options)
  throw new Error("component:#{name} does not exist") unless component
  component.append()
  components.push component
  return component

afterEach ->
  components.forEach (component)-> component.destroy()
