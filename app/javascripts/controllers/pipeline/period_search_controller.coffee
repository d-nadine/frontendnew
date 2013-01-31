Radium.PeriodSearchController = Em.ArrayController.extend
  quarters: ( ->
    quarters = []

    [1..4].forEach (num) =>
      quarters.pushObject(Em.Object.create({label: "Q#{num}", name: "q#{num}"}))

    quarters
  ).property('deals', 'deals.length')

  months: ( ->
    @get('deals').sort( (a, b) ->
      Ember.DateTime.compareDate(b.get('createdAt'), a.get('createdAt'))
    ).map((deal) ->
      "#{deal.get('createdAt').toFormattedString('%b')} - #{deal.get('createdAt.year')}"
    ).uniq()
  ).property('deals', 'deals.length')
