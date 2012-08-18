#  Core model class for all Radium models. Base attributes are `created_at` and `updated_at`

Radium.Core = DS.Model.extend
  createdAt: DS.attr("datetime", key: "created_at")
  updatedAt: DS.attr("datetime", key: "updated_at")
  updated_at: DS.attr("datetime")
  created_at: DS.attr("datetime")
  notes_attributes: DS.attr("array", defaultValue: [])
  comments: DS.hasMany "Radium.Comment",
    embedded: true
    key: "comments"
