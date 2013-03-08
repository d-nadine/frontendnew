Ember.View.reopen
  classNameBindings: ['viewClassName']

  viewClassName: (->
    constructor = @get('constructor').toString()

    return unless constructor.match /Radium/

    constructor.split('.')[1].dasherize()
  ).property()

