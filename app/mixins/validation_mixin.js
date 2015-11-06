import Ember from 'ember';

const {
  Mixin
} = Ember;

export const Validations = {
  required: function() {
    const value = this.get('value');

    const errorMessagePart = 'is a required field';

    let result;

    if (Ember.isEmpty(value)) {
      result = true;
    }

    if (typeof value !== "string") {
      result = false;
    }

    result = Ember.isEmpty($.trim(value));

    if (result) {
      this.addErrorMessage(errorMessagePart);
    } else {
      this.removeErrorMessage(errorMessagePart);
    }

    return result;
  },
  email: function() {
    const value = $.trim(this.get('value') || '');
    const errorMessagePart = 'should be a valid email address';
    const result = !Radium.EMAIL_REGEX.test(value);

    if (result) {
      this.addErrorMessage(errorMessagePart);
    } else {
      this.removeErrorMessage(errorMessagePart);
    }

    return result;
  },
  or: function() {
    const validator = this.get('validator');
    const orFields = validator.get('orFields');

    Ember.assert("You must declare orFields on the " + (this.get('validator').constructor.toString()) + " instance", orFields);

    const errorMessagePart = "should at least be chosen";

    const result = orFields.every(function(f) {
      return Ember.isEmpty(validator.get(f));
    });

    const otherValidators = this.get('validator.orValidators').reject((v) => {
      return v === this;
    });

    otherValidators.forEach((v) => {
      v.set('mainValidatorSyncing', true);
      v.set('mainValidatorIsInvalid', result);

      return v.notifyPropertyChange('isInvalid');
    });

    Ember.run.next(function() {
      otherValidators.forEach(function(v) {
        v.set('mainValidatorSyncing', false);
      });
    });

    if (result) {
      this.addErrorMessage(errorMessagePart);
      return result;
    }

    const errorMessages = this.get('validator.errorMessages').reject((m) => {
      return m.indexOf(errorMessagePart) > -1;
    });

    this.set('validator.errorMessages', errorMessages);

    return result;
  },

  custom: function() {
    const validationFunc = this.get('validationFunc');

    Ember.assert("You must supply a validationFunc for a custom validation", validationFunc);

    const result = validationFunc.call(this.get('validator'));

    if (result) {
      this.addErrorMessage(this.validationField);
    } else {
      this.removeErrorMessage(this.validationField);
    }

    return result;
  }
};

export const ValidationMixin = Mixin.create({
  classNameBindings: ['isInvalid'],

  input: function() {
    return this._super(...arguments);
  },

  addErrorMessage: function(errorMessagePart) {
    const errorMessage = this.get('validationField') + " " + errorMessagePart;

    this.get('validator.errorMessages').pushObject(errorMessage);
  },

  removeErrorMessage: function(errorMessagePart) {
    let errorMessages = this.get('validator.errorMessages');

    if (!errorMessages.get('length')) {
      return;
    }

    const regex = new RegExp((this.get('validationField')) + " " + errorMessagePart, 'gi');

    errorMessages = errorMessages.reject(function(m) {
      return regex.test(m);
    });

    this.set('validator.errorMessages', errorMessages);
  },

  validationInit: Ember.on('init', function() {
    this._super(...arguments);

    let validations;

    if (!(validations = this.get('validations'))) {
      return;
    }

    const validator = this.get('validator');

    let orValidators;

    if (validations.contains('or')) {
      if (!(orValidators = validator.get('orValidators'))) {
        validator.set('orValidators', []);
      }
      if (!validator.get('orValidators').contains(this)) {
        validator.get('orValidators').push(this);
      }
    }

    Ember.assert('You must spcecify a validator with validations.', validator);
    Ember.assert("You must specify a validation field to build error messages.", this.get('validationField'));

    Ember.assert("You need to initialize an errorMessages array for the ValidationMixin.", validator.get('errorMessages'));
  }),

  validationsLength: Ember.computed.oneWay('validations.length'),

  isInvalid: Ember.computed('validator.isSubmitted', 'validator.isValid', 'value', 'errorMessages.[]', function() {
    if (!this.get('validationsLength')) {
      return false;
    }

    if (this.get('mainValidatorSyncing')) {
      return this.get('mainValidatorIsInvalid');
    }

    const validator = this.get('validator');

    if (!validator.get('isSubmitted')) {
      return false;
    }

    if (validator.get('isValid')) {
      return false;
    }

    const validations = this.get('validations');

    const isInvalid = validations.any((v) => {
      return Validations[v].call(this);
    });

    return isInvalid;
  })
});
