import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

Component.reopen({
  classNameBindings: ['viewClassName'],

  viewClassName: computed(function() {
    const constructor = this.constructor.toString();

    if(!constructor.match(/radium/)) {
      return undefined;
    }

    if(!constructor.match(/@view/) && !constructor.match(/@component/)) {
      return undefined;
    }

    const result = constructor.split(':')[1].dasherize();

    if(!result.startsWith('-')) {
      return `${result}-component`;
    } else {
      return undefined;
    }
  })
});

DS.Model.reopenClass({
  humanize: function() {
    return this.toString().humanize();
  },
  instanceFromHash: function(hash, key, type, store) {
    const id = hash[key]["id"];
    const adapter = store.adapterForType(type);

    adapter.didFindRecord(store, type, hash, id);

    return type.find(id);
  }
});

DS.Model.reopen({
  humanize: function() {
    return this.constructor.humanize();
  }
});

String.prototype.pluralize = function() {
  if (this.toString() === 'company') {
    return "companies";
  }
  return this + "s";
};

String.prototype.singularize = function() {
  const map = {
    Companies: "company",
    emailMarkers: "Email Address",
    emailAddresses: "Email Address",
    phoneNumberMarkers: "Phone Number",
    phoneNumbers: "Phone Number"
  };

  let ret;

  if ((ret = map[this])) {
    return ret;
  } else {
    return this.replace(/s$/, '');
  }
};

String.prototype.capitalize = function() {
  return this.replace(/^([a-z])/, function(match) {
    return match.toUpperCase();
  });
};

String.prototype.humanize = function() {
  var str;
  str = this.replace(/_id$/, "").replace(/_/g, ' ').replace(/([a-z\d]*)/gi, function(match) {
    return match.toLowerCase();
  });
  return str = str.split('.').pop();
};

String.prototype.constantize = function() {
  return Ember.get(Radium, this.singularize().classify());
};

String.prototype.isCurrency = function() {
  return /^(?=.*[0-9])\d{1,15}(\.\d{1,2})?$/.test(accounting.unformat(this));
};

String.prototype.reformatHtml = function() {
   /*jshint -W049*/
  return this.replace(/<p[^>]*>/g, '').replace(/<\/p>/g, '\n\n').replace(/\<\div\>\<br\>\<\/div\>/i, '\n').replace(/<br\s*\/?>/ig, "\n").replace(/&nbsp;/g, ' ').replace(/(<([^>]+)>)/ig, "");
};

