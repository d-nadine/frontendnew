DS.Model.reopenClass
  humanize: ->
    @toString().humanize()

DS.Model.reopen
  humanize: ->
    @constructor.humanize()
