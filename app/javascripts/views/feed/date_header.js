Radium.DateHeaderView = Ember.View.extend({
  classNames: ['page-header', 'date-header'],
  templateName: 'date_section_header',
  contentBinding: 'parentView.content',
  didInsertElement: function(){
    var currentScrollTop =  this.$().offset().top;
    
    if(currentScrollTop < 100){
      $('html,body').scrollTop(this.$().offset().top -50);
    }  
  }
});
