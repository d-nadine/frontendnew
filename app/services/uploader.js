import Ember from 'ember';

const {
  Service,
  get,
  set,
  Evented
} = Ember;

export default Service.extend(Evented, {
  url: null,

  upload: function(file, extraData, url) {
    const data = this.setupFormData(file, extraData);

    if(!url) {
      url  = get(this, 'url');
    }

    Ember.assert("No url was found to for the uploader", url);

    set(this, 'isUploading', true);

    return this.ajax(url, data);
  },

  setupFormData: function(file, extraData) {
    var data = new FormData(),
        prop;

    for (prop in extraData) {
      if (extraData.hasOwnProperty(prop)) {
        data.append(prop, extraData[prop]);
      }
    }

    data.append('file', file);

    return data;
  },

  didProgress: function(e) {
    const total = e.total;
    const loaded = e.loaded;
    const percent = (100 / total) * loaded;

    this.trigger('progress', percent);
  },

  ajax: function(url, params, method) {
    const self = this;
    const settings = {
      url: url,
      type: method || 'POST',
      contentType: false,
      processData: false,
      xhr: function() {
        const xhr = Ember.$.ajaxSettings.xhr();
        xhr.upload.addEventListener("progress", function(e){
          if (e.lengthComputable) {
            self.didProgress(e);
          }
        }, false);
        return xhr;
      },
      data: params,
      headers: Ember.$.ajaxSettings.headers
    };

    return this._ajax(settings);
  },

  _ajax: function(settings) {
    const self = this;
    return new Ember.RSVP.Promise(function(resolve, reject) {
      settings.success = function(data) {
        set(self, 'isUploading', false);
        Ember.run(null, resolve, data);
      };

      settings.error = function(jqXHR) {
        set(self, 'isUploading', false);
        Ember.run(null, reject, jqXHR);
      };

      Ember.$.ajax(settings);
    });
  }
});
