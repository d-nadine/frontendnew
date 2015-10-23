export default function() {
  this.get('/users/me', function(db) {
    return {user: db.users.where({email: 'paul@radiumcrm.com'})[0]};
  });

  this.get('/conversations_totals', function(db) {
    return {conversations_totals: db['conversations-totals']};
  });

  this.get('/users', function(db) {
    return {users: db.users};
  });

  this.get('/lists', function(db) {
    return {lists: db.lists};
  });
}
