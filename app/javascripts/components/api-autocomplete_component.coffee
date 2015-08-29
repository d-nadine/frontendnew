require 'components/autocomplete-textbox_component'

Radium.ApiAutocompleteComponent = Radium.AutocompleteTextboxComponent.extend
  renderItems: (items) ->
    that = this

    items = $(items).map((i, item) ->
      html = that.highlighter(item)

      if logo = item.logo
        logo = item.logo + '?size=25x25'
        img = "<span class='auto-icon'><img  src='#{logo}'/></span>"
        html = img + html

      i = $(that.options.item).data('typeahead-value', item)
      i.find('a').html html
      i[0]
    )
    items.first().addClass 'active'
    @$menu.html items
    this

  asyncSource: (term, process) ->
    $.ajax
      url: "http://query.yahooapis.com/v1/public/yql",
      jsonp: "callback",

      dataType: "jsonp",

      data: {
        q: "select * from json where url=\"https://autocomplete.clearbit.com/v1/companies/suggest?query=#{term}&format=json\"",
        format: "json"
        },
      success: (response) ->
        unless results = response?.query?.results
          return

        process(results.json.json.map (r) -> Ember.Object.create r)

    null
