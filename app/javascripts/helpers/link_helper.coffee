Ember.TEMPLATES['links/user'] = Ember.Handlebars.compile "{{#link-to 'user' view.content}}{{view.content.firstName}}{{/link-to}}"
Ember.TEMPLATES['links/contact'] = Ember.Handlebars.compile """
  {{#link-to 'contact' view.content}}{{view.displayName}}{{/link-to}}

  {{#if view.company}}
    ({{#link-to 'company' view.company}}{{view.company.name}}{{/link-to}})
  {{/if}}
"""
Ember.TEMPLATES['links/company'] = Ember.Handlebars.compile "{{#link-to 'company' view.content}}{{view.content.name}}{{/link-to}}"
Ember.TEMPLATES['links/tag'] = Ember.Handlebars.compile "{{#link-to 'tag' view.content}}{{view.content.name}}{{/link-to}}"
Ember.TEMPLATES['links/deal'] = Ember.Handlebars.compile "{{#link-to 'deal' view.content}}{{view.content.name}}{{/link-to}}"
Ember.TEMPLATES['links/attachment'] = Ember.Handlebars.compile """
  <a href="{{url}}" target="_new">{{view.content.name}}</a>
"""
Ember.TEMPLATES['links/discussion'] = Ember.Handlebars.compile """
  {{#link-to 'unimplemented'}}{{truncate view.content.topic length=20}}{{/link-to}}
"""
Ember.TEMPLATES['links/meeting'] = Ember.Handlebars.compile "{{#link-to 'calendar.task' this}}{{view.content.topic}}{{/link-to}}"
Ember.TEMPLATES['links/email'] = Ember.Handlebars.compile """
  {{#if email.subject.length}}
    {{#link-to 'emails.show' 'inbox' view.content}}{{view.content.subject}}{{/link-to}}
  {{else}}
    {{#link-to 'emails.show' 'inbox' view.content}}(No Subject){{/link-to}}
  {{/if}}
"""
Ember.TEMPLATES['links/default'] = Ember.Handlebars.compile "{{view.displayName}}"

Radium.LinkView = Ember.View.extend
  tagName: "span"

  templateName: (->
    content = if @get('content') instanceof Ember.ObjectController
                @get('content.content')
              else
                @get('content')

    name = "links/#{content.constructor.toString().split('.')[1].underscore()}"
    name = "links/default" unless Ember.TEMPLATES[name]
    name
  ).property('content')

  displayName: (->
    @get('content.name') || @get('content.email') || @get('content.phoneNumber') || @get('content.primaryEmail.value') || @get('content.primaryPhone.value')
  ).property('content.name', 'content.email', 'content.phoneNumber', 'content.primaryEmail', 'content.primaryPhone', 'content')

  company: Ember.computed.alias('content.company')

# FIXME: Use regiserBoundHelper if a fix appears
Ember.Handlebars.registerHelper 'link', (path, options) ->
  model = options.contexts[0].get path
  options.hash.content = model

  return unless model
  return Ember.Handlebars.helpers.view.call(this, Radium.LinkView, options)
