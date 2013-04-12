Radium.LinkView = Ember.View.extend
  tagName: "span"

  template: Ember.Handlebars.compile """
    {{#if view.isUser}}
      {{#linkTo user view.content}}{{view.displayName}}{{/linkTo}}
    {{/if}}

    {{#if view.isContact}}
      {{#linkTo contact view.content}}{{view.displayName}}{{/linkTo}}

      {{#if view.company}}
        ({{#linkTo company view.company}}{{view.company.name}}{{/linkTo}}
      {{/if}}
    {{/if}}
  """

  isUser: (->
    @get('content') instanceof Radium.User
  ).property('content')

  isContact: (->
    @get('content') instanceof Radium.Contact
  ).property('content')

  displayName: (->
    @get('content.name') || @get('content.email') || @get('content.phoneNumber')
  ).property('content.name', 'content.email', 'content.phoneNumber')

  company: Ember.computed.alias('content.company')

Ember.Handlebars.registerBoundHelper 'link', (model, options) ->
  hash = options.hash
  hash.content = model

  return Ember.Handlebars.helpers.view.call(this, Radium.LinkView, options)
