Radium.EmailsShowView = Radium.View.extend Radium.ScrollTopMixin,
  actions:
    showExtension: ->
      document.getElementById('show-extension').click()
      @get('controller').send 'dismissExtension'
