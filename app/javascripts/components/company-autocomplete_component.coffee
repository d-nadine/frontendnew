require 'components/autocomplete-textbox_component'

Radium.CompanyAutocompleteComponent = Radium.AutocompleteTextboxComponent.extend
  renderItems: (items) ->
    that = this

    items = $(items).map((i, item) ->
      html = that.highlighter(item)

      if logo = item.logo
        logo = item.logo + '?size=25x25'
        img = "<span class='auto-icon'><img  src='#{logo}'/></span>"
      else
        img = "<span class='auto-icon'><img  src='#{"http://res.cloudinary.com/radium/image/upload/v1441015721/default_avatars/unknown.gif"}'/></span>"

      html = img + html

      i = $(that.options.item).data('typeahead-value', item)
      i.find('a').html html
      i[0]
    )
    items.first().addClass 'active'
    @$menu.html items
    this

  scopes: ['company']

  asyncSource: (term, process) ->
    @set 'isLoading', false

    external =
      $.ajax
        url: "http://query.yahooapis.com/v1/public/yql",
        jsonp: "callback",

        dataType: "jsonp",

        data: {
          q: "select * from json where url=\"https://autocomplete.clearbit.com/v1/companies/suggest?query=#{term}&format=json\"",
          format: "json"
        }

    internalQuery =
      like: term,
      page_size: 25

    internal = Radium.Company.find(internalQuery)

    Ember.RSVP.hash(
      external: external
      internal: internal
    ).then((hash) ->
      internalResults = if hash.internal.get('length')
                          internal.map (i) ->
                            Ember.Object.create(id: i.get('id'), name: i.get('name'), website: i.get('website'), logo: null)
                        else
                          []


      stripDomain = (url) ->
        url.replace(/.*?:\/\//g, "").replace(/\/$/, '').toLowerCase()

      domains = internalResults.map((r) ->
        if url = r.get('website')
          stripDomain(url)
        else
          null
      ).compact()

      externalResults = if r = hash.external?.query?.results
                          r.json.json.map((e) ->
                           Ember.Object.create(id: null, name: e.name, website: e.domain, logo: e?.logo)).reject((r) ->
                               unless url = r.get('website')
                                 false

                               domains.contains stripDomain(url)
                             )
                        else
                          []

      combined = externalResults
                   .concat(internalResults)

      process(combined)
    ).catch((error) ->
      Ember.Logger.error(error)
    ).finally =>
      @set 'isLoading', false

    null
