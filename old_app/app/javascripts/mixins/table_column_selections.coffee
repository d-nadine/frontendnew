Radium.TableColumnSelectionsMixin = Ember.Mixin.create
  actions:
    toggleColumnVisibility: ->
      Ember.assert "You must specify a columnSelectionKey", @columnSelectionKey
      Ember.run.next =>
        checked = @get('checkedColumns').filter((c) -> c.checked).mapProperty 'id'

        return unless checked.length

        localStorage.setItem @columnSelectionKey, JSON.stringify(checked)

      false
