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

  this.get('/contacts/:id', function(db, fakeRequest) {
    return {contact: db.contacts.where({id: fakeRequest.params.id})[0]};
  });

  this.put('/contacts/:id', function(db, fakeRequest) {
    const id = fakeRequest.params.id,
          attrs = JSON.parse(fakeRequest.requestBody).contact,
          record = db.contacts.update(id, attrs);

    return {
      contact: record
    };
  });

  this.get('/conversations/:type', function(db, fakeRequest) {
    const type = fakeRequest.params.type;

    let filter;

    if(type === "incoming") {
      filter = (email) => {
        return email.folder === 'INBOX';
      };
    } else {
      filter = () => {
        return false;
      };
    }

    const emails = db.emails.filter(filter);

    return {emails: emails};
  });
}
