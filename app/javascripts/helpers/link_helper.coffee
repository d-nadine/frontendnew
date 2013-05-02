Ember.TEMPLATES['links/user'] = Ember.Handlebars.compile "{{#linkTo user view.content}}{{view.displayName}}{{/linkTo}}"
Ember.TEMPLATES['links/contact'] = Ember.Handlebars.compile """
  {{#linkTo contact view.content}}{{view.displayName}}{{/linkTo}}

  {{#if view.company}}
    ({{#linkTo company view.company}}{{view.company.name}}){{/linkTo}}
  {{/if}}
"""
Ember.TEMPLATES['links/company'] = Ember.Handlebars.compile "{{#linkTo company view.content}}{{view.content.name}}{{/linkTo}}"
Ember.TEMPLATES['links/group'] = Ember.Handlebars.compile "{{#linkTo unimplemented}}{{view.content.name}}{{/linkTo}}"
Ember.TEMPLATES['links/deal'] = Ember.Handlebars.compile "{{#linkTo deal view.content}}{{view.content.name}}{{/linkTo}}"
Ember.TEMPLATES['links/attachment'] = Ember.Handlebars.compile """
  <a href="{{unbound url}}" target="_new">{{view.content.name}}</a>
"""
Ember.TEMPLATES['links/discussion'] = Ember.Handlebars.compile """
  {{#linkTo unimplemented}}{{truncate view.content.topic length=20}}{{/linkTo}}
"""

Radium.LinkView = Ember.View.extend
  tagName: "span"

  templateName: (->
    "links/#{@get('content.constructor').toString().split('.')[1].underscore()}"
  ).property('content')

  displayName: (->
    @get('content.name') || @get('content.email') || @get('content.phoneNumber')
  ).property('content.name', 'content.email', 'content.phoneNumber')

  company: Ember.computed.alias('content.company')

Ember.Handlebars.registerBoundHelper 'link', (model, options) ->
  hash = options.hash
  hash.content = model

  return Ember.Handlebars.helpers.view.call(this, Radium.LinkView, options)
