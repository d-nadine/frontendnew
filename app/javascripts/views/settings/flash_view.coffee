# Note: This could be moved into the global folder, but just to all
# the files in this branch contained to primarily settings folders
# I've set this up in here for now. Move at your own discretion
Radium.SettingsFlashView = Ember.View.extend
  classNames: 'alert fade'
  classNameBindings: 'controller.type'
  templateName: 'settings/flash'

  didInsertElement: ->
    @$()[0].outerHeight
    @$().addClass('in')

    setTimeout(=>
      @close()
    , 4000)

  # For this to work, ensure that the flash message is placed in a `flash` outlet
  close: ->
    @$().one($.support.transition.end, =>
      @get('parentView').disconnectOutlet('flash')
    ).removeClass('in')