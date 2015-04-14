Ember.View.reopen
  classNameBindings: ['viewClassName']

  viewClassName: Ember.computed ->
    constructor = @get('constructor').toString()

    return unless constructor.match /Radium/
    return unless constructor.match(/View$/) || constructor.match(/Component$/)

    constructor.split('.')[1].dasherize()
