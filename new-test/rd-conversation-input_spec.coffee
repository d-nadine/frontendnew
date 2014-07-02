describe "RdConversationInputComponent", ->
  beforeEach ->
    @input = component 'rdConversationInput'
    @$ = @input.$.bind(@input)

  it "renders itself", ->
    expect(@$().attr("class")).to.match /rd-conversation-input/
