Radium.AddressInlineEditor = Radium.InlineEditorView.extend
  isValid: true
  companyBinding: 'controller.company'
  addresses: Radium.MultipleFields.extend
    labels: ['Office','Home']
    leader: 'Address'
    sourceBinding: 'controller.addresses'
    viewType: Radium.AddressMultipleField
    type: Radium.Address

  companyDidChange: ( ->
    return if @get('company.addresses.length') > 1
    return if !@get('company') || !@get('company.primaryAddress')

    @get('controller.addresses').clear()

    @get('controller.addresses').createRecord(@get('company.primaryAddress').serialize())
  ).observes('company')

  primaryAddress: ( ->
    address = @get('controller.primaryAddress')

    [address.get('state'), address.get('city'), address.get('zipcode')].join(', ')
  ).property('controller.primaryAddress')

  template: Ember.Handlebars.compile """
    <div>
      {{#if view.isEditing}}
        <h2>Address</h2>
        <div>
          {{view view.addresses}}
        </div>
      {{else}}
        <h2>Address <i class="icon-edit pull-right" {{action toggleEditor target=view bubbles=false}}></i></h2>
        {{#if primaryAddress}}
          {{#with primaryAddress}}
            <div class="readonly">
              <i class="icon-office pull-right"></i>
              <div>{{street}}</div>
              <div>{{view.primaryAddress}}</div>
              <div>{{country}}</div>
              <div class="location">
                <a href="#"><i class="icon-location"></i></a>
              </div>
            </div>
          {{/with}}
        {{/if}}
      {{/if}}
    </div>
  """
