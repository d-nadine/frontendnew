import Ember from 'ember';

import AutocompleteMixin from "radium/mixins/autocomplete-mixin";

import UploadingMixin from "radium/mixins/uploading-mixin";
import ContentEditableBehaviour from "radium/mixins/contenteditable-behaviour";

import {TAB, ENTER, ARROW_UP, ARROW_DOWN} from "radium/utils/key-constants";

import {TemplatePlaceholderMap, FallbackMap} from "radium/mixins/editor-mixin";

import rangy from "radium/utils/rangy";

const {
  Component
} = Ember;

export default Component.extend(AutocompleteMixin, UploadingMixin, ContentEditableBehaviour, {
  actions: {
    setBindingValue: function(placeholder) {
      this.$('ul.typeahead').remove();

      let field,
          template;

      if ((field = placeholder.get('field'))) {
        this.onCustomFieldInserted(field);
      } else if ((template = placeholder.get('template'))) {
        this.sendAction("insertTemplate", template);
      } else {
        this.onPlaceholderInserted(placeholder);
      }
      this.transitionToEditing();
    }
  },

  classNameBindings: [':richtext-editor', 'isInvalid'],
  btnSize: 'bth-xs',
  height: 120,
  files: Ember.computed.alias('targetObject.files'),

  isRichTextEditor: true,

  _initialize: Ember.on('init', function() {
    this.EventBus.subscribe('email:reset', this, 'onFormReset');
    this.EventBus.subscribe('placeholderInserted', this, 'onPlaceholderInserted');
    this.EventBus.subscribe('customFieldInserted', this, 'onCustomFieldInserted');
    this.EventBus.subscribe('insertTemplate', this, 'onTemplateInserted');
    this.EventBus.subscribe('removePlaceHolder', this, 'onRemovePlaceHolder');
  }),

  setup: Ember.on('didInsertElement', function() {
    const textarea = this.$('textarea');

    textarea.summernote({
      height: this.get('height'),
      toolbar: [['style', ['bold', 'italic', 'underline', 'clear']], ['fontsize', ['fontsize']], ['color', ['color']], ['para', ['ul', 'ol', 'paragraph']], ['height', ['height']], ['insert', ['link', 'picture']], ['table', ['table']], ['help', ['help']], ['misc', ['codeview', 'undo', 'redo']]]
    });

    textarea.code(this.get('content'));

    this.$('.btn').addClass(this.get('btnSize'));

    Ember.run.scheduleOnce('afterRender', this, 'addOverrides');

    const superFunc = this.__nextSuper.bind(this);

    Ember.run.next(function() {
      return superFunc();
    });
  }),

  onFormReset: function() {
    const editable = this.$('.note-editable');

    if (!editable) {
      return;
    }
    this.set('placeholderShown', false);
    editable.addClass('placeholder');
    this.set('content', '');
    editable.html('');

    Ember.run.next(() => {
      editable.addClass('placeholder').one('focus', this.removePlaceHolder.bind(this));
    });
  },
  removePlaceHolder: function(clearHtml) {
    if (clearHtml == null) {
      clearHtml = true;
    }

    if (this.get('placeholderShown')) {
      return;
    }

    const editable = this.$('.note-editable');

    if (!editable.length) {
      return;
    }

    if (!editable.hasClass('placeholder')) {
      return;
    }

    editable.removeClass('placeholder');

    if (clearHtml) {
      editable.html('');
    }

    this.set('placeholderShown', true);
  },
  addOverrides: function() {
    Ember.run.next(() => {
      const typeahead = this.getTypeahead();

      typeahead.show = this.showTypeahead.bind(typeahead);

      const typeaheadProcess = typeahead.process;
      const typeaheadHide = typeahead.hide;

      typeahead.hide = function() {
        this.transitionToEditing();
        return typeaheadHide.apply(typeahead, arguments);
      };

      typeahead.process = function() {
        if (this.inEditingState()) {
          return null;
        }

        return typeaheadProcess.apply(typeahead, arguments);
      };

      const typeaheadKeydown = typeahead.keydown.bind(typeahead);

      typeahead.keyDown = null;
      typeahead.$element.off('keydown');

      const keyDownHanlder = function(e) {
        const keyCode = e.keyCode;

        if (this.inEditingState() || [TAB, ENTER, ARROW_UP, ARROW_DOWN].contains(keyCode)) {
          return typeaheadKeydown(e);
        }

        if (keyCode === this.ESCAPE) {
          this.transitionToEditing();
          return false;
        }

        if (keyCode === this.DELETE) {
          this.query = this.query.slice(0, this.query.length - 1);
          return false;
        }

        this.query += String.fromCharCode(e.keyCode);
        return false;
      };

      typeahead.keydown = keyDownHanlder;
      typeahead.$element.on('keydown', keyDownHanlder.bind(typeahead));

      typeahead.$element.off('blur');
      typeahead.inEditingState = this.inEditingState.bind(this);

      typeahead.blur = null;
    });

    const editable = this.$('.note-editable');

    const tabindex = this.get('tabindex');

    if (tabindex) {
      editable.attr('tabindex', tabindex);
    }

    if (!this.get('content.length')) {
      editable.addClass('placeholder').one('focus', this.removePlaceHolder.bind(this));
    }

    const dropdowns = $('[data-toggle=dropdown]');

    dropdowns.dropdown();

    const dropzone = this.$(".note-dropzone");

    const drop = this.richTextAreaDrop.bind(this);

    dropzone.off("drop").on("drop", drop);
  },

  richTextAreaDrop: function(e) {
    const files = e.dataTransfer.files;

    if (!files.length) {
      return null;
    }

    this.uploadFiles(files);

    $(document).trigger('drop');

    e.preventDefault();

    return false;
  },

  teardown: Ember.on('willDestroyElement', function() {
    this.EventBus.unsubscribe('email:reset');
    this.EventBus.unsubscribe('placeholderInserted');
    this.EventBus.unsubscribe('customFieldInserted');
    this.EventBus.unsubscribe('insertTemplate');
    this.EventBus.unsubscribe('removePlaceHolder');
    this._super.apply(this, arguments);
    this.$('.note-editable').off('focus');
    this.$('textarea').destroy();

    this.$(".note-dropzone").off('drop');
  }),

  editorState: 'editing',

  inEditingState: function() {
    return this.editorState === "editing";
  },

  inTemplateSelection: function() {
    return this.editorState === "templateSelection";
  },

  transitionToEditing: function() {
    this.set('editorState', 'editing');
    this.query = "";

    const typeahead = this.$('ul.typeahead');

    if (typeahead.length) {
      return typeahead.remove();
    }
  },

  keyDown: function(e) {
    if (this.inTemplateSelection()) {
      return false;
    }
    if (e.keyCode === this.OPEN_CURLY_BRACE) {
      this.query = "{";
      this.set('editorState', "templateSelection");
      return false;
    }
    if (e.keyCode === this.DELETE) {
      const range = rangy.getRange();
      const parentNode = range.startContainer.parentNode;

      if (parentNode.className !== "remove-template-item") {
        return null;
      }

      $(parentNode.parentNode).remove();

      e.stopPropagation();

      return false;
    }

    return this.doUpdate();
  },

  click: function(e) {
    if (e.target.className === "remove-template-item") {
      $(e.target.parentNode).remove();
      e.stopPropagation();
      return false;
    }
    this.doUpdate();
    return $('[data-toggle=dropdown]').each(function() {
      return $(this).parents('.btn-group.open').removeClass('open');
    });
  },

  doUpdate: function() {
    Ember.run.next(() => {
      const content = this.$('.note-editable').html();
      return this.set('content', content);
    });
  },

  onRemovePlaceHolder: function() {
    return this.removePlaceHolder(false);
  },

  onCustomFieldInserted: function(customField) {
    const node = "<span data-custom-field-id=\"" + (customField.get('id')) + "\" class=\"badge badge-info template-item\">" + (customField.get('name')) + " | \"fall back\"&nbsp;<span class=\"remove-template-item\" href=\"#\">x</span></span>";

    this.insertPlaceholder(node);
  },
  onPlaceholderInserted: function(placeholder) {
    const text = TemplatePlaceholderMap[placeholder.name] || '';

    Ember.assert("Placeholder was not found for " + placeholder.name, text.length);
    const fallback = FallbackMap[placeholder.name] || "";

    const node = "<span data-place-holder=\"" + placeholder.name + "\" class=\"badge badge-info template-item\">" + text + " | \"" + fallback + "\"&nbsp;<span class=\"remove-template-item\" href=\"#\">x</span></span>";

    this.insertPlaceholder(node);
  },
  insertPlaceholder: function(nodeText) {
    if (!this.get('placeholderShown')) {
      this.removePlaceHolder();
    }

    const editable = this.$('.note-editable');

    editable.focus();

    const sel = window.getSelection();

    const range = sel.getRangeAt(0);

    range.deleteContents();

    const node = $(nodeText)[0];

    range.insertNode(node);

    const space = document.createElement("span");

    space.innerHTML = "\u200B";

    $.summernote.core.dom.insertAfter(space, node);

    Ember.run.next(() => {
      const sel = window.getSelection();
      sel.collapse(space.firstChild, 1);
      return space.focus();
    });

    this.doUpdate();

    return false;
  },

  onTemplateInserted: function(template) {
    const editable = this.$('.note-editable');

    editable.focus();
    this.insertHtml(template.get('html'));

    Ember.run.next(() => {
      this.doUpdate();
    });
  },

  placeholderShown: false,

  autocompleteElement: function() {
    return this.$('.note-editable');
  },

  showTypeahaedWhenEmpty: false,

  showTypeahead: function() {
    var current, editor, lastNode, positioning, range, selection;

    if ($('ul.typeahead').is(':visible')) {
      return null;
    }

    selection = rangy.getSelection();
    range = selection.getRangeAt(0).cloneRange();
    editor = $('.note-editable');
    current = document.getSelection().anchorNode;
    lastNode = current === editor.get(0) ? editor.get(0).firstChild : current;
    lastNode = lastNode || range.endContainer;

    $.summernote.core.dom.insertAfter(this.$menu.get(0), lastNode);

    positioning = editor.is(':empty') ? editor.position() : {
      top: 'auto',
      left: 'auto'
    };

    this.$menu.css({
      top: positioning.top,
      left: positioning.left,
      display: 'inline-table'
    });

    window.setTimeout(() => {
      this.$menu.show();
    }, 100);

    this.shown = true;
    return this;
  }
});
