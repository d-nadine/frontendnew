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

  this.get('/companies/:id', function(db, fakeRequest) {
    return {company: db.companies.where({id: fakeRequest.params.id})[0]};
  });

  this.get('/users/:user_id/activities', function(db) {
    return {
      activities: db.activities,
      meta: {
        page: 1,
        total_records: 0,
        total_pages: 1,
        last_page: true
      }
    };
  });

  this.get('/autocomplete', function(db, fakeRequest) {
    const query = getUrlParts(fakeRequest.url);
    const scope = query[1].scopes;
    const term = query[0].term.toLowerCase();

    let results = [];

    if(scope === "company") {
      const companies = server.db.companies.filter((company) => {
        return  ~term.indexOf(company.name.toLowerCase()) > -1;
      });

      results = companies.map((company) => {
        return {
          id: company.id + 8,
          name: company.name,
          displayName: company.name,
          resource_id: company.id,
          _person_company_id: company.id,
          email: null
        };
      });
    }

    return {autocomplete: results};
  });

  this.put('/contacts/:id', function(db, fakeRequest) {
    const id = fakeRequest.params.id,
          attrs = JSON.parse(fakeRequest.requestBody).contact,
          record = db.contacts.update(id, attrs);

    if(attrs.company_name) {
      const company = db.companies.where({name: attrs.company_name})[0];

      record.company_id = company.id;
    }

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

function getUrlParts(url) {
  const vars = [];
  const hashes = url.slice(url.indexOf('?') + 1).split('&');

  for(var i = 0; i < hashes.length; i++) {
    let values = hashes[i].split('=');

    const part = {};

    part[values[0]] = values[1];
    vars.push(part);
  }
  return vars;
}
