Ember.Object.reopen
  toHash: ->
    excluded = ['isNew']
    ret = {}

    for prop in Object.keys(this)
      if this.hasOwnProperty(prop) && !excluded.contains(prop)
        ret[prop] = this[prop]

    ret

this.oldDasherize = String.prototype.dasherize

self = this

String.prototype.dasherize = ->
  self.oldDasherize.call(this).replace(/\//g, '-')
