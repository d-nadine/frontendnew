(function() {

var get = Ember.get,
    set = Ember.set;

Ember.Uploader = Ember.Object.extend(Ember.Evented, {
  url: null,

  upload: function(file) {
    var model = this.get('model');
    var extraData = {type: model.humanize(), id: model.get('id')};
    var data = this.setupFormData(file, extraData);
    var url  = get(this, 'url');
    var self = this;

    set(this, 'isUploading', true);

    return this.ajax(url, data).then(function(respData) {
      self.didUpload(respData);
      return respData;
    });
  },

  setupFormData: function(file, extraData) {
    var data = new FormData();

    for (var prop in extraData) {
      if (extraData.hasOwnProperty(prop)) {
        data.append(prop, extraData[prop]);
      }
    }

    data.append('file', file);

    return data;
  },

  didUpload: function(data) {
    set(this, 'isUploading', false);

    this.trigger('didUpload', data);
  },

  didProgress: function(e) {
    var total = e.total;
      var loaded = e.loaded;
      var percent = (100 / total) * loaded;
    this.trigger('progress', percent);
  },

  ajax: function(url, params, method) {
    var self = this;
    var settings = {
      url: url,
      headers: {
        'X-Ember-Compat': true,
        'X-User-Token': Radium.get('authManager.token')
      },
      type: method || 'POST',
      contentType: false,
      processData: false,
      xhr: function() {
        var xhr = Ember.$.ajaxSettings.xhr();
        xhr.upload.addEventListener("progress", function(e){
          if (e.lengthComputable) {
            self.didProgress(e);
          }
        }, false);
        return xhr;
      },
      data: params
    };

    return this._ajax(settings);
  },

  _ajax: function(settings) {
    return new Ember.RSVP.Promise(function(resolve, reject) {
      settings.success = function(data) {
        Ember.run(null, resolve, data);
      };

      settings.error = function(jqXHR, textStatus, errorThrown) {
        Ember.run(null, reject, jqXHR);
      };

      Ember.$.ajax(settings);
    });
  }
});


})();

(function() {

var set = Ember.set;

Ember.FileField = Ember.TextField.extend({
  type: 'file',
  attributeBindings: ['multiple'],
  multiple: true,
  change: function(e) {
    var input = e.target;
    if (!Ember.isEmpty(input.files)) {
      set(this, 'files', input.files);
    }
  }
});


})();
