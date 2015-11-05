import Ember from 'ember';
import BufferedProxy from 'ember-buffered-proxy/proxy';
import ContentEditableBehaviour from 'radium/mixins/contenteditable-behaviour';

import {ENTER, ESCAPE} from "radium/utils/key-constants";

const {
  Component
} = Ember;

export default Component.extend(ContentEditableBehaviour, {
 actions: {
   activateLink: function() {
     const target = this.get('containingController');

     let routeAction,
         routable,
         queryParams;

     if ((routeAction = this.get("routeAction"))) {
       return target.send(routeAction, this.get('model'));
     }

     const alternative = this.get('alternativeRoute');

     if(alternative) {
       routable = this.get('model').get(alternative);
     } else {
       routable = this.get('model');
     }

     if ((queryParams = this.get('queryParams'))) {
       return target.transitionToRoute(routable.humanize(), routable, {
         queryParams: queryParams
       });
     } else {
       return target.transitionToRoute(routable.humanize(), routable);
     }
   },

   updateModel: function() {
     if (this.get('actionOnly')) {
       return null;
     }

     const bufferedProxy = this.get('bufferedProxy');

     if (!bufferedProxy) {
       return null;
     }

     const model = this.get('model');
     const bufferKey = this.get('bufferKey');

     let modelValue;

     if(model && model.get && model.get(bufferKey)) {
       modelValue = model.get(bufferKey);
     } else {
       modelValue = '';
     }

     const value = bufferedProxy.get(this.get('bufferKey')) || '';

     if (!bufferedProxy.hasBufferedChanges) {
       if (bufferedProxy.get('isNew') || !value.length) {
         this.send('setPlaceholder');
       }
       return null;
     }

     if ($.trim(value).length || modelValue.length) {
       return Ember.run.debounce(this, 'send', ['saveField'], 200);
     }

     return this.send('setPlaceholder');
   },

   saveField: function() {
     if (!this.get('isSaving')) {
       return this.completeSave();
     }

     const observer = () => {
       if(this.get('isSaving')) {
         return;
       }

       this.removeObserver("isSaving", observer);

       this.completeSave();
     };

     return this.addObserver('isSaving', observer);
   },

   setPlaceholder: function() {
     var el;
     if (!(el = this.$())) {
       return;
     }
     el.html("<em class='placeholder'>" + (this.get('placeholder')) + "</em>");
   }
 },

  completeSave: function() {
    const bufferedProxy = this.get('bufferedProxy');

    if (!bufferedProxy) {
      return null;
    }

    const bufferKey = this.get('bufferKey');

    let model = this.get('model');

    const nullModelType = this.get('nullModelType');

    if (!model && nullModelType) {
      model = nullModelType.createRecord();
      bufferedProxy.set('content', model);
      this.set('model', model);
      this.notifyPropertyChange('model');
      this.notifyPropertyChange('bufferedProxy');
      this.notifyPropertyChange("bufferedProxy." + bufferKey);
    }

    if (!model) {
      return this.flashMessenger.error("No model is associated with this record");
    }

    if (!bufferedProxy.hasBufferedChanges) {
      return null;
    }

    const backup = model.get(bufferKey);

    const resetModel = () => {
      bufferedProxy.discardBufferedChanges();
      bufferedProxy.set(bufferKey, backup);
      model.set(bufferKey, backup);
      model.reset();
      this.get('markUp');
      this.setMarkup();
    };

    if (this.get('isInvalid')) {
      this.get('containingController').send('flashError', 'Field is not valid.');
      if (model) {
        return resetModel();
      } else {
        return null;
      }
    }

    this.set('isSaving', true);

    let saveAction,
        beforeSave;

    if ((saveAction = this.get("saveAction"))) {
      this.get('containingController').send(saveAction, this);

      if (this.get('actionOnly')) {
        return null;
      }
    }

    bufferedProxy.applyBufferedChanges();

    if ((beforeSave = this.get('beforeSave'))) {
      this.get('containingController').send(beforeSave, this);
    }

    const self = this;

    model.save().then(() => {
      this.set('isSaving', false);

      const value = this.get('model').get(this.get('bufferKey')) || '';

      Ember.run.next(() => {
        this.EventBus.publishModelUpdate(model);
      });

      let afterSave;

      if ((afterSave = this.get('afterSave'))) {
        Ember.assert("You have a containing controller", this.get('containingController'));
        this.get('containingController').send(afterSave, this);
      }

      if(!value.length) {
        return this.send('setPlaceholder');
      }

      const observer = () => {
        if(model.currentState.stateName !== "root.loaded.saved") {
          return;
        }

        model.removeObserver("currentState.stateName", observer);

        if(this.get('alternativeRoute')) {
          this.notifyPropertyChange('model');

          this.$().html(self.get('markUp'));
        }
      };

      if(model.currentState.stateName === "root.loaded.saved") {
        observer();
      } else {
        model.addObserver('currentState.stateName', observer);
      }
    }).finally(() => {
      this.set('isSaving', false);
    });
  },
  classNames: ['editable'],
  classNameBindings: ['isSaving', 'isInvalid'],
  attributeBindings: ['contenteditable'],
  isTransitioning: false,
  contenteditable: "false",

  bufferedProxy: Ember.computed('model', function() {
    return BufferedProxy.create({
      content: this.get('model')
    });
  }),

  route: Ember.computed("model", 'alternativeRoute', 'notRoutable', function() {
    var alternative, routable;
    if (this.get('notRoutable')) {
      return null;
    }
    routable = (alternative = this.get('alternativeRoute')) ? (alternative = this.get('model').get(alternative)) ? alternative : void 0 : this.get('model');
    if (!routable) {
      return null;
    }
    return "/" + (routable.humanize().pluralize()) + "/" + (routable.get('id'));
  }),

  _initialize: Ember.on('init', function() {
    this._super(...arguments);

    const bufferKey = this.get('bufferKey');
    const modelDep = "model." + bufferKey;
    const bufferDep = "bufferedProxy." + bufferKey;

    Ember.defineProperty(this, 'markUp', Ember.computed(bufferDep, 'route', 'alternativeRoute', modelDep, function() {
      const value = function(_this) {
        const potential = _this.get('bufferedProxy').get(_this.get('bufferKey'));

        if(!potential) {
          return null;
        }

        if (potential instanceof DS.Model) {
          return potential.get('displayName');
        }

        return potential;
      }(this);

      if (!value) {
        return '';
      }

      if (this.get('route')) {
        return "<a class='route' href='" + (this.get('route')) + "'>" + value + "</a>";
      } else if (this.get('routeAction')) {
        return "<a class='route' href='#'>" + value + "</a>";
      } else if (this.get('externalUrl')) {
        const url = Radium.Url.resolve(value);
        return "<a href='" + url + "' target='_blank'>" + value + "</a>";
      } else {
        return value;
      }
    }));

    if (!(this.get('validator') || this.get('isRequired'))) {
      return;
    }

    let validator, validatorRegex;

    if ((validator = this.get('validator'))) {
      if (typeof validator === "string") {
        validatorRegex = new RegExp(validator);
      } else {
        validatorRegex = validator;
      }
    }

    Ember.defineProperty(this, 'isInvalid', Ember.computed(bufferDep, 'isRequired', function() {
      const value = this.get('bufferedProxy').get(bufferKey);

      if (this.get('isRequired') && !value) {
        return true;
      }

      if (!value) {
        return false;
      }

      if (!validatorRegex) {
        return false;
      }

      const isInvalid = !validatorRegex.test(value);

      return isInvalid;
    }));
  }),
  modelIdentifier: null,

  setup: Ember.on('didInsertElement', function() {
    this._super(...arguments);

    this.$().parent().on('click', this.clickHandler.bind(this));
    this.$().on('focus', this.focusContent.bind(this));

    const bufferKey = this.get('bufferKey');
    const modelDep = "model." + bufferKey;

    let model;

    if (!(model = this.get('model'))) {
      return this.setMarkup();
    }

    const observer = () => {
      if(!model.get('isLoaded')) {
        return;
      }

      this.notifyPropertyChange(modelDep);
      this.setMarkup();
      model.removeObserver('isLoaded', observer);
    };

    if (!model) {
      return null;
    }

    let hoverAction;

    if ((hoverAction = this.get('hoverAction'))) {
      const hoverSelector = this.get('elementId');
      this.set('hoverSelector', hoverSelector);
      const target = this.get('containingController');

      this.$().on("mouseenter." + hoverSelector, "a.route", () => {
        target.send(hoverAction, this.get('model'));
      });
    }

    if (!model.get('isLoaded')) {
      Ember.run.next(() => {
        this.$().html("<em class='loading'>Loading....</em>");
        model.addObserver('isLoaded', observer);
      });
    } else {
      this.setMarkup();
    }

    if (!model.updatedEventKey) {
      return null;
    }
    this.modelIdentifier = model.updatedEventKey();

    this.EventBus.subscribe(this.modelIdentifier, this, "rerenderModel");
  }),
  rerenderModel: function() {
    return this.setMarkup(true);
  },
  teardown: Ember.on('willDestroyElement', function() {
    this._super(...arguments);

    const el = this.$();

    if(!el || !el.length) {
      return;
    }

    el.parent().off('click');
    el.off('focus', this.focusContent.bind(this));

    const hoverSelector = this.get('hoverSelector');

    if(hoverSelector) {
      el.off(`mouseenter.${hoverSelector}`);
    }

    const model = this.get('model');

    if(!model) {
      return;
    }

    const modelIdentifier = this.get('modelIdentifier');

    if(!modelIdentifier) {
      return;
    }

    this.EventBus.unsubscribe(modelIdentifier);
  }),

  setMarkup: function(dont) {
    if (dont == null) {
      dont = false;
    }

    const markUp = this.get('markUp');

    let el;

    if (!(el = this.$())) {
      return;
    }
    if (!(markUp != null ? markUp.length : void 0)) {
      this.send('setPlaceholder');
    } else {
      el.html(markUp);
    }

    if (!dont) {
      this.setEndOfContentEditble();
    }
  },

  input: function() {
    const text = this.get('multiline') ? this.$().html() : this.$().text();

    this.get('bufferedProxy').set(this.get('bufferKey'), text);

    const el = this.$();
    const anchor = el.find('a');
    const updateEl = anchor.length ? anchor : el;

    updateEl.html(this.get('value'));
  },

  keyDown: function(e) {
    var bufferedProxy, markUp;
    bufferedProxy = this.get('bufferedProxy');
    if (e.keyCode === ENTER) {
      if (this.get('multiline')) {
        e.preventDefault();
        this.insertLineBreak();
        return false;
      }

      Ember.run.next(() => {
        return this.send('updateModel');
      });

      this.$().blur();

      return false;
    }

    if (e.keyCode === ESCAPE) {
      bufferedProxy.discardBufferedChanges();
      markUp = this.get('markUp');
      this.setMarkup();
      return false;
    }

    return true;
  },

  clickHandler: function(e) {
    if (this.contenteditable === "true") {
      return;
    }
    if ($(e.target).hasClass('route')) {
      this.send('activateLink');
      return false;
    }

    this.enableContentEditable();
  },
  enableContentEditable: function() {
    if (!this.$().length) {
      return;
    }

    const el = this.$();
    const parent = el.parent();
    parent.css('text-overflow', 'clip');
    Ember.run((function(_this) {
      return function() {
        return _this.set("contenteditable", "true");
      };
    })(this));

    Ember.run.next(() => {
      this.setEndOfContentEditble();
      return parent.scrollLeft(el.width());
    });
  },
  focusContent: function() {
    if (!this.$().length) {
      return;
    }

    const el = $(this.$());
    const value = this.get('bufferedProxy').get(this.bufferKey);

    if (!value) {
      el.empty();
    }

    el.parents('td:first').addClass('active');

    this.enableContentEditable();
  },
  focusOut: function() {
    Ember.run.next(() => {
      this.send('updateModel');
    });

    if (!this.$().length) {
      return;
    }

    const el = this.$();

    this.set("contenteditable", "false");
    el.parents('td:first').removeClass('active');
    el.parent().css('text-overflow', 'ellipsis');

    this.send("updateModel");
  },

  isRequired: false
});
