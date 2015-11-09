import Ember from 'ember';

import {
  ARROW_DOWN,
  ARROW_UP,
  ARROW_LEFT,
  ARROW_RIGHT,
  ESCAPE,
  TAB,
  ENTER
}
from "radium/utils/key-constants";

const {
  Mixin
} = Ember;

export default Mixin.create({
  actions: {
    setBindingValue: function() {
      throw new Error('subclasses need to override setBindingValue');
    }
  },

  isLoading: false,

  isAsync: Ember.computed.not('source'),

  matchesSelection: function(value) {
    if (!value) {
      return false;
    }

    const active = this.$('.typeahead .active');

    let selected;

    if (active.is(':visible')) {
      selected = active.text() || active.val();
    }
    if (!selected) {
      return false;
    }

    if(!value) {
      return false;
    }

    return (value.toLowerCase() === selected.toLowerCase());
  },
  setValue(object, index) {
    const self = this;
    const el = self.autocompleteElement();

    const finish = function(value) {
      self.send('setBindingValue', object, index);

      if (self.isAutocompleteTextBox|| self.isRichTextEditor) {
        return;
      }

      const isInput = el.get(0).tagName === "INPUT";

      Ember.run.next(() => {
        if (isInput) {
          el.val(value);
        } else {
          el.text(value);
        }
        return self.send('updateModel');
      });
    };

    if (typeof object === "string") {
      return finish(object);
    }

    if (!(object instanceof DS.Model)) {
      return finish(this.getValue(object));
    }
    this.set('isLoading', true);

    const subject = object.get('person') || object;

    const observer = () => {
      if (!subject.get('isLoaded')) {
        return;
      }
      this.set('isLoading', false);

      subject.removeObserver('isLoaded');

      finish(this.getValue(object));
    };

    if (subject.get('isLoaded')) {
      return observer();
    } else {
      return subject.addObserver('isLoaded', observer);
    }
  },

  getValue(item) {
    if (typeof item === "string") {
      return item;
    } else {
      const field = this.field;

      return item.get(field) || item[field];
    }
  },

  resolveQuery(query) {
    if (!query) {
      return "";
    }
    if (query instanceof DS.Model) {
      return query.get(this.queryKey);
    }
    return query;
  },

  queryParameters(query) {
    const scopes = this.get('scopes');

    Ember.assert("You need to define a scopes binding for autocomplete", scopes);

    const params = {
      term: query,
      scopes: scopes
    };
    if (!this.get('tracked_only')) {
      return params;
    }
    params.tracked_only = true;

    return params;
  },

  matcher(item) {
    var query, string;
    string = this.getValue(item);
    query = this.resolveQuery(this.query);

    if (!query) {
      return false;
    }

    if (!string) {
      return false;
    }

    return ~string.toLowerCase().indexOf(query.toLowerCase());
  },

  sorter(items) {
    const beginswith = [];
    const caseSensitive = [];
    const caseInsensitive = [];
    const query = this.resolveQuery(this.query);

    items.forEach((item) => {
      let string = this.getValue(item);

      if (!string.toLowerCase().indexOf(query.toLowerCase())) {
        beginswith.push(item);
      } else if (~string.indexOf(query)) {
        caseSensitive.push(item);
      } else {
        caseInsensitive.push(item);
      }
    });

    return beginswith.concat(caseSensitive, caseInsensitive);
  },
  holder: "",

  highlighter: function(item) {
    const string = this.getValue(item);
    let query = this.resolveQuery(this.query);

    query = query.replace(/[\-\[\]()*+?.,\\\^$|#\s]/g, '\\$&');

    return string.replace(new RegExp('(' + query + ')', 'ig'), function($1, match) {
      return "<strong>" + match + "</strong>";
    });
  },

  updater: function(item) {
    return this.set('value', item);
  },

  autocompleteElement: function() {
    throw new Error('You must override autocompleteElement in subclass.');
  },

  autocompleteItemType: function() {
    return this.get('autocompleteType') || Radium.AutocompleteItem;
  },

  getTypeahead: function() {
    return this.autocompleteElement().data('typeahead');
  },

  asyncSource: function(query, process) {
    const queryParameters = this.queryParameters(query);

    this.set('isLoading', true);

    this.autocompleteItemType().find(queryParameters).then((results) => {
      return process(results);
    }).finally(() => {
      return this.set('isLoading', false);
    });

    return;
  },

  showTypeahead() {
    const pos = $.extend({}, this.$element.position(), {
      height: this.$element[0].offsetHeight
    });

    this.$menu.insertAfter(this.$element).css({
      top: pos.top + pos.height,
      left: pos.left
    }).show();

    this.shown = true;

    return this;
  },

  showTypeahaedWhenEmpty: true,

  renderItems(items) {
    const that = this;

    items = $(items).map(function(i, item) {
      i = $(that.options.item).data('typeahead-value', item);
      i.find('a').html(that.highlighter(item));
      return i[0];
    });

    this.$menu.html(items);

    return this;
  },
  setup: Ember.on('didInsertElement', function() {
    this._super.apply(this, arguments);
    if (this.getField) {
      this.field = this.getField.call(this);
    } else {
      this.field = this.get('queryKey');
    }

    let bindingKey,
        binding;

    if (this.bindQuery) {
      bindingKey = this.bindQuery.call(this);
      binding = Ember.bind(this, 'query', bindingKey);
    } else {
      binding = Ember.bind(this, 'query', "holder");
    }

    const el = this.autocompleteElement.call(this);

    Ember.assert("No autocompleteElement found", el.length);

    const isAsync = this.get('isAsync');

    if (!this.get('source')) {
      el.typeahead({
        source: this.asyncSource.bind(this)
      });
    } else {
      el.typeahead({
        source: this.get('source')
      });
    }

    const typeahead = el.data('typeahead');

    if (isAsync) {
      typeahead.options.minLength = 1;
    }

    const showTypeahaedWhenEmpty = this.get('showTypeahaedWhenEmpty');

    typeahead.lookup = function() {
      this.query = this.$element.text() || this.$element.val();
      if (isAsync && (!this.query || this.query.length < this.options.minLength)) {
        if (this.shown) {
          return this.hide();
        } else {
          return this;
        }
      }

      let items;

      if ($.isFunction(this.source)) {
        items = this.source(this.query, $.proxy(this.process, this));
      } else {
        items = this.source;
      }

      if (!isAsync && !this.query && items.get('length') && showTypeahaedWhenEmpty) {
        return this.render(items.slice(0, this.options.items)).show();
      }

      if (items) {
        return this.process(items);
      } else {
        return this;
      }
    };

    typeahead.process = function(items) {
      items = items.filter((item) => {
        return this.matcher(item);
      });

      items = this.sorter(items);

      if (!items.get('length')) {
        if (this.shown) {
          return this.hide();
        } else {
          return this;
        }
      }

      return this.render(items.slice(0, this.options.items)).show();
    };
    typeahead.render = this.renderItems.bind(typeahead);
    typeahead.matcher = this.matcher.bind(this);
    typeahead.sorter = this.sorter.bind(this);
    typeahead.highlighter = this.highlighter.bind(this);
    typeahead.show = this.showTypeahead.bind(typeahead);

    typeahead.select = function() {
      var active, index, val;
      active = this.$menu.find('.active');
      val = active.data('typeahead-value');
      index = this.$menu.find('li').index(active);
      this.updater(val, index);
      return this.hide();
    };

    typeahead.updater = (item, index) => {
      this.setValue(item, index);
    };

    typeahead.constructor.prototype.keyup = function(e) {
      switch (e.keyCode) {
      case ARROW_DOWN:
      case ARROW_UP:
      case ARROW_LEFT:
      case ARROW_RIGHT:
        break;
      case TAB:
      case ENTER:
        if (!this.shown) {
          return;
        }
        this.select();
        break;
      case ESCAPE:
        if (!this.shown) {
          return;
        }
        this.hide();
        break;
      default:
        this.lookup();
      }
      e.stopPropagation();

      e.preventDefault();
    };
  })
});
