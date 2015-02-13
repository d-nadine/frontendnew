require 'views/multiple/multiple_base_view'

Radium.MultipleAddressView = Radium.MultipleBaseView.extend
  click: (e) ->
    if parent = $(e.target).parents('.country-picker')
      if parent.length
        $(e.target).parents('.country-picker').toggleClass 'open'

    e.stopPropagation()
    e.preventDefault()
    false
