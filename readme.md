# Radium Frontend

This README outlines the details of collaborating on this Ember application.
A short introduction of this app could easily go here.

## Prerequisites

You will need the following things properly installed on your computer.

* [Git](http://git-scm.com/)
* [Node.js](http://nodejs.org/) (with NPM)
* [Bower](http://bower.io/)
* [Ember CLI](http://www.ember-cli.com/)
* [PhantomJS](http://phantomjs.org/)

## Installation

* `git clone <repository-url>` this repository
* change into the new directory
* `npm install`
* `bower install`

## Running / Development

* `ember server`
* Visit your app at [http://localhost:4200](http://localhost:4200).

### Code Generators

Make use of the many generators for code, try `ember help generate` for more details

### Running Tests

* `ember test`
* `ember test --server`

The ember tests use [mirage](http://www.ember-cli-mirage.com/docs/v0.1.x/) to remove some of the drudgerry in creating test data.

### Ember Data
The frontend codebase uses a patched up version of the old ```0.14.0``` branch.  Any chnages to the code must be made to [this repo](https://github.com/radiumsoftware/data) and deployed to ```~/vendor/javascripts/ember-data.js```.

Any new or existing model class needs to extend ```Radium.Model``` (```~/app/models/models.js```).

For example the ```Contact``` model class located in ```app/models/contact.js``` extends ```Radium.Model``` and any new model classes need to take an identitical approach.


```
import Model from 'radium/models/models';
import Ember from 'ember';

const {
  computed
} = Ember;

const Contact = Model.extend({
// props
});

export default Contact;

Contact.toString = function() {
  return "Radium.Contact";
};

```


All ember-data model classes that extend ```Radium.Model``` need to be added to the global application namespace in the ```old-model-compat``` instance initializer ```~/app/instance-initializers/old-model-compat.js```, e.g:

```
import Todo from "radium/models/todo";

export function initialize(application) {
  // we need to set this reference to the application
  // instance for this version of ember-data
  window.Radium = application;

  application.Todo = Todo;
}


export default {
  name: 'old-model-compat',
  initialize: initialize,
  before: 'store-compatibility'
};

```

Ember-data specific mapping and other config can be found in ```~/app/adapters/rest.js```.  Not all the classes and mappings have been migrated from the master branch and the code will need to be uncommented as the remaining classes are migrated.

This version of ember-data has been extended to be promise based:


```
// get all
// the empty hash is sadly important in this version of ember-data
Radium.Contact.find({}).then((results) => {
  //do stuff
});

//saving or updating
const contact = Radium.Contact.createRecord({name: 'blah'});

contact.save().then((results) => {
  //do stuff
}).finally(() => {
  //do stuff
});

// deleting
contact.delete().then(() => {
});
```

### Building

* `ember build` (development)
* `ember build --environment production` (production)

### Deploying

Preliminary work:

* `ember install ember-cli-deploy`
* `ember install ember-cli-deploy-build`
* `ember install ember-cli-deploy-scp`

Deployment process:

* `ember deploy staging`
OR
* `ember deploy production`

Our deployment process is super simple. Ember application is built locally and scp to remote host.
Remote deployment dir is `/var/www/radium-front`.
Remote latest build symlink is `/var/www/radium-front/current/web`.

## Further Reading / Useful Links

* [ember.js](http://emberjs.com/)
* [ember-cli](http://www.ember-cli.com/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)

``
