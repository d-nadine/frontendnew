import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

import Url from "radium/utils/url";

export default Component.extend({
  tagName: 'a',


  attributeBindings: ['href', 'target'],

  classNameBindings: ['hasMedia:active'],

  personsMedia: computed('person.contactInfo.socialProfiles.[]', 'person.socialProfiles.[]', 'socialMedia', function() {
    var socialMedia, socialProfiles;
    socialMedia = this.get('socialMedia');
    if (!(socialProfiles = this.get('person.contactInfo.socialProfiles') || this.get('person.socialProfiles.[]'))) {
      return null;
    }

    return socialProfiles.find(function(p) {
      return p.get('type') === socialMedia;
    });
  }),

  hasMedia: computed.bool('personsMedia'),

  href: computed('personsMedia', 'hasMedia', function() {
    if (!this.get('hasMedia')) {
      return "#";
    }

    return Url.resolve(this.get('personsMedia.url'));
  }),

  badge: computed('socialMedia', function() {
    return `ss-${this.get('socialMedia')}`;
  }),

  target: "_new",

  click: function(e) {
    if (!this.get('hasMedia')) {
      return e.preventDefault();
    }

    return this._super(...arguments);
  }
});
