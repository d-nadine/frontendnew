# TODO: maybe it would be nice to handle queuing arrays added
#       with load. for now it's handled in router, but this
#       implementation is not bullet proof
Radium.ExpandableRecordArray = DS.RecordArray.extend
  isLoading: false

  loadRecord: (record) ->
    if record.get('isLoaded')
      @get('content').pushObject record.get('clientId')
      return

    @set 'isLoading', true
    self = this

    observer = ->
      if @get 'isLoaded'
        content = self.get 'content'

        record.removeObserver 'isLoaded', observer
        content.pushObject record.get('clientId')

        self.set 'isLoading', false

    record.addObserver 'isLoaded', observer

  load: (array) ->
    @set 'isLoading', true
    self = this

    observer = ->
      if @get 'isLoaded'
        content = self.get 'content'

        array.removeObserver 'isLoaded', observer
        array.forEach (record) ->
          clientId = record.get 'clientId'
          unless content.contains clientId
            content.pushObject clientId

        self.set 'isLoading', false

    array.addObserver 'isLoaded', observer
