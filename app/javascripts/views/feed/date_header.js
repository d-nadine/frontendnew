Radium.DateHeaderView = Ember.View.extend({
  classNames: ['page-header', 'date-header'],
  templateName: 'date_section_header',
  contentBinding: 'parentView.content',
  didInsertElement: function(){
    var self = this;
    $('html,body').animate({
      scrollTop: self.$().offset().top -50
    }, 2000);
  }
});
