describe "RdConversationInputComponent", ->
  before ->
    Ember.run =>
      @input = Radium.__container__.lookup("component:rdConversationInput")
      @input.append()
      @$ = @input.$.bind(@input)
  after ->
    Ember.run =>
      @input.destroy()
  it "renders itself", ->
    ok(@$().attr("class").match /rd-conversation-input/)
