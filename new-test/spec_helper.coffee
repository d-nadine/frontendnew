minispade.require "boot"
Ember.testing = true
Radium.setupForTesting()
Radium.injectTestHelpers()
Radium.set('rootElement', 'body')


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
