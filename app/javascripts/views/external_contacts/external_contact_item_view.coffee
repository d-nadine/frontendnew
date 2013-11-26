Radium.ExternalContactItemView = Radium.View.extend Radium.ContentIdentificationMixin,
  templateName: 'external_contacts/external_contact_item'
  dataModel: (->
    Radium.ExternalContact.toString()
  ).property('controller.content')


