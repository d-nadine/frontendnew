Ember.TEMPLATES['links/user'] = Ember.Handlebars.compile "{{#linkTo 'user' view.content}}{{view.content.firstName}}{{/linkTo}}"
Ember.TEMPLATES['links/contact'] = Ember.Handlebars.compile """
  {{#linkTo 'contact' view.content}}{{view.displayName}}{{/linkTo}}

  {{#if view.company}}
    ({{#linkTo 'company' view.company}}{{view.company.name}}{{/linkTo}})
  {{/if}}
"""
Ember.TEMPLATES['links/company'] = Ember.Handlebars.compile "{{#linkTo 'company' view.content}}{{view.content.name}}{{/linkTo}}"
Ember.TEMPLATES['links/tag'] = Ember.Handlebars.compile "{{#linkTo 'tag' view.content}}{{view.content.name}}{{/linkTo}}"
Ember.TEMPLATES['links/deal'] = Ember.Handlebars.compile "{{#linkTo 'deal' view.content}}{{view.content.name}}{{/linkTo}}"
Ember.TEMPLATES['links/attachment'] = Ember.Handlebars.compile """
  <a href="{{unbound url}}" target="_new">{{view.content.name}}</a>
"""
Ember.TEMPLATES['links/discussion'] = Ember.Handlebars.compile """
  {{#linkTo 'unimplemented'}}{{truncate view.content.topic length=20}}{{/linkTo}}
"""
Ember.TEMPLATES['links/meeting'] = Ember.Handlebars.compile "{{#linkTo 'unimplemented'}}{{view.content.topic}}{{/linkTo}}"
Ember.TEMPLATES['links/email'] = Ember.Handlebars.compile "{{#linkTo 'emails.show' view.content}}{{view.content.subject}}{{/linkTo}}"
Ember.TEMPLATES['links/default'] = Ember.Handlebars.compile "{{view.displayName}}"

Radium.LinkView = Ember.View.extend
  tagName: "span"

  templateName: (->
    name = "links/#{@get('content.constructor').toString().split('.')[1].underscore()}"
    name = "links/default" unless Ember.TEMPLATES[name]
    name
  ).property('content')

  displayName: (->
    @get('content.name') || @get('content.email') || @get('content.phoneNumber')
  ).property('content.name', 'content.email', 'content.phoneNumber')

  company: Ember.computed.alias('content.company')

# FIXME: Use regiserBoundHelper if a fix appears
Ember.Handlebars.registerHelper 'link', (path, options) ->
  model = options.contexts[0].get path
  options.hash.content = model

  return unless model
  return Ember.Handlebars.helpers.view.call(this, Radium.LinkView, options)
