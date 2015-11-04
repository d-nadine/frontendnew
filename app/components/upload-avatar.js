import Ember from 'ember';

const {
  Component,
  computed
} = Ember;

export default Component.extend({
  isLargeAvatar: computed('avatarsize', function() {
    return this.get('avatarsize') === "large";
  }),

  change(e) {
    if (!e.target.files.length) {
      return;
    }

    const file = e.target.files[0];
    const url = (this.get('store._adapter.url')) + "/avatars";

    Ember.assert("No url was found for the upload-avatar component", url);

    const uploader = this.get('uploader');
    const model = this.get('model');

    const modelAttributes = {
      type: model.humanize(),
      id: model.get('id')
    };

    this.set('isUploading', true);

    uploader.upload(file, modelAttributes, url).then((data) => {
      const store = this.get('store');
      const adapter = store.adapterForType(model.constructor);

      adapter.didFindRecord(store, model.constructor, data, model.get('id'));

      this.set('isUploading', false);

      Ember.run.next(() => {
        this.sendAction('finishedUpload');
      });
    }).catch(() => {
      this.flashMessenger.error('an error has occurred and the avatar cannot be uploaded');
      this.set('isUploading', false);
    });
  }
});
