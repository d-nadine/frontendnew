Radium.GapView = Em.View.extend
  templateName: 'radium/gap'
  classNames: ['gap']
  loadLimit: 3

  click: ->
    @get('controller').load
      startDate: @get('startDate')
      endDate: @get('endDate')
