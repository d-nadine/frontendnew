import Ember from 'ember';

const {
  Mixin
} = Ember;

export default Mixin.create({
  percentage: 0,
  uploadFiles: function(files) {
    this.get('uploader').on('progress', this, 'onDidProgress');
    this.set('disableSave', true
            );
    const uploader = this.get('uploader');

    const uploadToFiles = this.get('files');

    Ember.assert("You have not set the files array for UploadingMixin in " + (this.constructor.toString()), uploadToFiles);

    let i;

    for (i = 0; i < files.length; i++) {
      let file = files[i];

      let wrappedFile = Ember.Object.create(file, {
        file: file,
        isUploading: true
      });

      uploadToFiles.pushObject(wrappedFile);

      let model = this.get('model'),
          hash;

      if(model && model.humanize) {
        hash = {
          id: model.get('id'),
          type: model.humanize()
        };
      } else {
        hash = { bucket: this.get('bucket') };
      }

      uploader.upload(file, hash)
        .then(this.handlerFactory(wrappedFile).bind(this))
        .catch((error) => {
          Ember.logger.error(error);

          this.flashMessenger.error('an error has occurred and the file could not be uploaded.');
        });
    }
    return false;
  },

  handlerFactory(wrappedFile) {
    return (data) => {
      const id = data["attachment"]["id"];
      const store = this.get("controller.store");
      const adapter = store.adapterForType(Radium.Attachment);

      adapter.didFindRecord(store, Radium.Attachment, data, id);

      const attachment = Radium.Attachment.find(id);

      if (attachment.get('reference')) {
        attachment.get('reference').reload();
      }

      wrappedFile.set('isUploading', false);
      wrappedFile.set('attachment', attachment);

      const isUploading = this.get('files').any(function(file) {
        return file.get('isUploading');
      });

      return this.set('disableSave', isUploading);
    };
  },

  onDidProgress(percent) {
    if(this.isDestroyed || this.isDestroying) {
      return;
    }

    this.set('percent', percent);
  },

  isUploadingDidChange: Ember.observer('uploader.isUploading', function() {
    if(this.isDestroyed || this.isDestroying) {
      return;
    }

    this.set('percent', 1);
  })
});