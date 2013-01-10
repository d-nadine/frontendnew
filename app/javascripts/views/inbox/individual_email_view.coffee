Radium.IndividualEmailView = Em.View.extend
  # templateName: 'radium/inbox/email'
  template: Ember.Handlebars.compile('<div>here it is</div>')
  classNames: 'email fadeIn'.w()
  # didInsertElement: ->
  #   @_super.apply this, arguments
  #   active = $('ul.messages li.active')
  #   return if active.length == 0

  #   setTimeout(( ->
  #     $('div.arrow').css(top: active.offset().top - 35))
  #     , 200)
  # willDestroyElement: ->
  #   @$().removeClass('fadeIn').addClass('fadeOut')

