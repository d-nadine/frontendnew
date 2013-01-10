Radium.ContactCardView = Ember.View.extend
  templateName: "radium/contact_card"
  classNames: "contact-card row span9".w()
  classNameBindings: ["content.isSelected:selected"]
  #  selectedFilterBinding: "Radium.selectedContactsController.selectedFilter"
  #  selectedLetterBinding: "Radium.selectedContactsController.selectedLetter"
  #isVisible: ->
  #  status = @getPath("content.status")
  #  todos = @getPath("data.todos.length")
  #  firstLetter = @getPath("content.firstLetter")
  #  isAssigned = @getPath("content.user")
  #  selectedLetter = @get("selectedLetter")
  #  selectedFilter = @get("selectedFilter")
  #  unless selectedFilter
  #    return false  if selectedLetter isnt firstLetter  if selectedLetter
  #  else
  #    return false  if isAssigned  if selectedFilter is "unassigned"
  #    return false  if todos > 0  if selectedFilter is "no_tasks"
  #    return false  if status isnt selectedFilter
  #    return false  if selectedLetter isnt firstLetter  if selectedLetter
  #  true
  #.property("selectedFilter", "selectedLetter", "content.firstLetter", "content.status", "content.unassigned", "content.todos").cacheable()
  #contactPageLink: Ember.View.extend(
  #  tagName: "a"
  #  attributeBindings: ["href"]
  #  href: ->
  #    "/contacts/%@".fmt @getPath("content.id")
  #  .property("content")
  #)
  #sendContactMessage: (event) ->
  #  contact = @get("content")
  #  contact.set "isSelected", true
  #  Radium.App.send "addResource",
  #    form: "ContactsMessage"
  #    data: contact

  #  false
