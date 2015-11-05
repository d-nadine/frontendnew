import Ember from 'ember';

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
