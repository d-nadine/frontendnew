Radium.AddressMultipleField = Radium.MultipleField.extend
  template: Ember.Handlebars.compile """
    <div class="addresses">
      <div class="control-group whole">
        {{view Ember.TextField classNames="field input-xlarge" valueBinding="view.current.value.street" placeholderBinding="view.leader"}}
      </div>
      <div class="control-group whole">
        {{view Ember.TextField  valueBinding="view.current.value.city" classNames="field input-xlarge city" placeholder="City"}}
      </div>
      <div class="control-group broken">
        {{view Ember.TextField valueBinding="view.current.value.state" classNames="field state" placeholder="State" }}
        {{view Ember.TextField valueBinding="view.current.value.zipcode" classNames="field zip" placeholder="Zip code"}}
      </div>
    </div>
  """
  showAddNew: ( ->
    index = @get('index')
    sourceLength = (@get('source.length') - 1)
    return false if index == sourceLength
    return false if @get('parentView.currentIndex') == sourceLength

    true
  ).property('showdropdown', 'parentview.currentindex','current.value.street', 'current.value.city', 'current.value.state', 'current.value.zip')
