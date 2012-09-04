# helpers for interacting with the application through UI

window.addTodo = (item, section, callback) ->
  waitForResource item, (el) ->
    el.click()

    waitForSelector ['.add-todo', el], (el) ->
      el.click()

      waitForSelector '.radium-form', (el) ->
        Ember.run ->
          $('.more-options', el).click()

        fillIn '#finish-by-date', section.get('id')
        fillIn '#description', 'New todo'
        enterNewLine('#description')

        waitForResource section, (el) ->
          callback()
