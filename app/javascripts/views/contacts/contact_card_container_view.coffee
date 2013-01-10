require 'radium/views/contacts/contact_card_view'

Radium.ContactCardContainerView = Ember.ContainerView.extend
  classNames: "contact-card-container".w()
  init: ->
    @_super()
    @set "childViews", []
    content = @get("content")
    contactCard = Radium.ContactCardView.create(content: content)
    @set "currentView", contactCard
