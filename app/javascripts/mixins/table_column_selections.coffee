Radium.TableColumnSelectionsMixin = Ember.Mixin.create
  actions:
    toggleColumnVisibility: ->
      Ember.run.next =>
        checked = @get('checkedColumns').filter((c) -> c.checked).mapProperty 'id'

        return unless checked.length

        localStorage.setItem @SAVED_COLUMNS, JSON.stringify(checked)
