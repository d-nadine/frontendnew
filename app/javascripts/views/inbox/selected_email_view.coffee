Radium.SelectedEmailView = Em.View.extend
  templateName: 'radium/inbox/selected_email'
  classNames: 'alert alert-info'.w()
  didInsertElement: ->
    @$().slideUp(0)
    @$().slideDown(250, "easeInOutQuad")
  willDestroyElement: ->
    @$().fadeOut(250)

