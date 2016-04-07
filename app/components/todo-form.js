import Ember from 'ember';
import FormBase from 'radium/components/form-base';

export default FormBase.extend({
  needs: ['users'],
  timer: null,

  isCalendar: Ember.computed.equal('controllers.application.currentPath', 'calendar.task'),
  animate: Ember.computed.not('isCalendar'),
  showSuccess: Ember.computed.alias('justAdded'),
  isDisabled: Ember.computed.bool('justAdded'),

  _initialize: Ember.on('init', function() {
    this._super.apply(this, arguments);
    return this.EventBus.subscribe("todo:formSubmitted", this, 'formSubmitted');
  }),

  overdueText: Ember.computed('finishBy', function() {
    return "Was due on " + (this.get('finishBy').toHumanFormat());
  }),

  cantFinish: Ember.computed('isDisabled', 'isNew', function() {
    return this.get('isDisabled') || this.get('isNew');
  }),

  isValid: Ember.computed('description.length', 'finishBy', 'user', 'model.submitForm', function() {
    var finishBy;
    if (Ember.isEmpty(this.get('description').trim())) {
      return;
    }
    finishBy = this.get('finishBy');
    if (finishBy && finishBy.isBeforeToday()) {
      return;
    }
    if (!this.get('user')) {
      return;
    }
    return true;
  }),

  isBulk: Ember.computed('reference', function() {
    return Ember.isArray(this.get('reference'));
  }),

  showComments: Ember.computed('isNew', 'justAdded', 'isBulk', function() {
    if (this.get('isBulk')) {
      return false;
    }
    if (this.get('justAdded')) {
      return false;
    }
    if (!this.get('id')) {
      return false;
    }
    return true;
  }),

  justAdded: Ember.computed('content.justadded', function() {
    return this.get('content.justAdded') === true;
  }),

  hasReference: Ember.computed('reference', 'isNew', function() {
    var reference;
    reference = this.get('reference');
    return !this.get('isNew') && reference;
  }),

  placeholder: Ember.computed(/*'reference.name', */'finishBy', function() {
    let pre = '';
    if(this.get('referenceName') && !this.get('reference.token')) {
      pre = "Add a todo about #{this.get('referenceName')}";
    } else {
      pre = "Add a todo";
    }
    if(!this.get('finishBy')) {
      return pre;
    }
    return "#{pre} for #{this.get('finishBy').toHumanFormat()}";
  }),

  isPrimaryInputDisabled: Ember.computed('isDisabled', 'isExpanded', 'isNew', function() {
    if (this.get('isNew')) {
      return false;
    }
    if (!this.get('isExpanded')) {
      return true;
    }
    return this.get('isDisabled');
  }),

  formSubmitted: function() {
    return this.send('submit');
  },


  didInsertElement: function() {
    this.set('store', this.get('store'));
    this.set('model', this.get("model"));
    if (!this.get('overdue')) {
      return;
    }
    return Ember.run.scheduleOnce('afterRender', this, '_afterRender');
  },
  _afterRender: function() {
    var _ref;
    if (!this.get('overdue')) {
      return;
    }
    return (_ref = this.$('.overdue-alert')) != null ? _ref.tooltip({
      html: true
    }) : void 0;
  },
  _teardown: Ember.on('willDestroyElement', function() {
    var alert;
    this._super.apply(this, arguments);
    this.EventBus.unsubscribe("todo:formSubmitted");
    if (alert = this.$('.overdue-alert')) {
      return alert.tooltip('destroy');
    }
  }),
  onFormReset: function() {},

  actions: {
    finishTask() {
      var timer;
      if (this.get('cantFinish')) {
        return;
      }
      this.toggleProperty('isFinished');
      if (this.get('isCalendar')) {
        if (this.get("hasBufferedChanges")) {
          this.send('completeFinish');
        }
        return;
      }
      if (this.get('isFinished') && this.get('hasBufferedChanges')) {
        timer = setInterval((function(_this) {
          return function() {
            _this.send('completeFinish');
            return clearInterval(timer);
          };
        })(this), 2000);
        this.set('timer', timer);
      } else {
        if (this.get('timer')) {
          clearInterval(this.get('timer'));
        }
        if (this.get("hasBufferedChanges")) {
          this.send('completeFinish');
        }
      }
      return false;
    },

    completeFinish() {
      var currentPath, ele, finish, model, reference, self, store, user;
      model = this.get('model');
      user = model.get('user');
      reference = model.get('reference');
      currentPath = this.get('controllers.application.currentPath');
      store = this.get('store');
      ele = Ember.$("[data-model='" + model.constructor + "'][data-id='" + (model.get('id')) + "']");
      self = this;
      finish = function() {
        var isFinished;
        isFinished = !!!model.get('isFinished');
        model.set('isFinished', isFinished);
        return model.save().then(function() {
          if (currentPath !== 'user.index') {
            if (user != null) {
              user.reload();
            }
          }
          if (!reference) {
            return;
          }
          return reference.reload();
        });
      };
      if (!this.get('animate')) {
        return finish();
      }
      return ele.fadeOut(function() {
        return finish();
      });
    },

    submit() {
      this.set('isSubmitted', true);
      if (!this.get('isValid')) {
        this.set('isExpanded', true);
        return;
      }
      this.set('isExpanded', false);
      this.set('justAdded', true);
      return Ember.run.later(((function(_this) {
        return function() {
          var data, model;
          _this.set('justAdded', false);
          _this.set('isSubmitted', false);
          _this.applyBufferedChanges();
          model = _this.get('model');
          if (_this.get('isNew')) {
            model.commit().then((function(result) {
              var contact, _ref;
              if (_this.get('controllers.application.currentPath') !== 'user.index') {
                if ((_ref = _this.get('user')) != null) {
                  _ref.reload();
                }
              }
              if (result != null ? result.confirmation : void 0) {
                _this.send('flashSuccess', result.confirmation);
              }
              if (contact = result.todo.get('_referenceContact')) {
                contact.reload();
              }
              if (_this.get('target') instanceof Radium.NextTaskComponent) {
                return _this.get('target').send('todoAdded', result.todo);
              }
            }), (function(error) {
              return _this.send('flashError', error);
            }));
          } else {
            if (!_this.get('model.finishBy')) {
              data = _this.get('data');
              data.finishBy = null;
              model.set('_data', data);
            }
            _this.send('addErrorHandlersToModel', model);
            model.save().then(function(result) {
              var contact;
              if (contact = result.get('_referenceContact')) {
                return contact.reload();
              }
            });
          }
          /*Ember.run.next(function() {
           var parentController;
           if (parentController = _this.get('parentController')) {
           if (parentController instanceof Radium.CalendarTaskController) {
           return parentController.get('controllers.calendarSidebar').notifyPropertyChange('items');
           }
           }
           });*/ // Will be implemented later
          /*if (_this.get('parentController') instanceof Radium.CalendarTaskController) {
           _this.set('isExpanded', true);
           }*/ // Will be converted later
          _this.discardBufferedChanges();
          if (!_this.get('isNew')) {
            return;
          }
          _this.get('model').reset();
          return _this.trigger('formReset');
        };
      })(this)), 1200);
    },

    trySubmit() {
      if (this.get('isNew')) {
        return;
      }
      return this.send('submit');
    }
  },
});
