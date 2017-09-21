# MongoDB Shell Commands

db    # show current db
show dbs
db mycustomers    # create db and switch to it
use <name of db>  # switch to existing db
db.createUser({user:"Jose", pwd:"1234",roles: [ "readWrite", "dbAdmin" ]});
show users
db.dropDatabase()   # delete current database
db.createCollection('customers');
show collections

a={first_name:"Albert", last_name:"Einstein"}
db.customers.save(a)
db.customers.remove(a)
coll = db.customers
coll.save(a)

### find( <query> , <projection>)  <projection> is optional
# Find documents matching the <query> criteria and return just specific fields in the <projection>
db.customers.find()
db.customers.find({last_name:"Einstein"},{first_name:true})   # return first_name of all entires matching last_name
db.customers.find().pretty();
db.mycollection.find({ "price" : { "$exists" : false } })  # find all docs without "price" field

### sort(<sort order>)  1=ascending, -1=descending
db.customers.find().sort({last_name:true}).pretty();  

### count()
### skip(< n >)  Skip n results
### limit(< n >)  Limit to n results
coll.find().limit(5)

### findOne( <query> )  return single doc or null if not found

### insert( <doc> or <array_of_docs> )   same as save()
db.customers.insert({first_name:"John", last_name:"Doe", age:"30"});
coll.insert(a)

### update( <query> , <update> )  where <update> is a document to replace the match
### update( <query> , <update> , { upsert: boolean, multi: boolean } )
        # upsert - if no doc match found, create doc
        # multi - update multiple docs that match
db.customers.update({first_name:"Mary"},{first_name:"Mary",last_name:"Samson"},{upsert: true});   # if Mary not found, create entry

### To modify rather than replace: <update> document can contain "update operators": $inc, $set, etc.
# In this scenario, <update> must contain only update operators and update() only updates the specified fields
db.costumers.update({first_name:"John"},{$set:{last_name:"Denver"}});
db.costumers.update({first_name:"John"},{$inc:{age:5}});
db.customers.update({first_name:"John"},{$unset:{age:true}});  # delete age field

### Remove
db.customers.remove({first_name:"John"}); # deletes all matches
db.customers.remove({first_name:"John"},{justOne:true}); # deletes first match found

### Other operators
db.customers.find({$or:[{first_name:"John"},{first_name:"Sharon"}]});   # find records matching either names
db.customers.find({age:{$lt:40}}).pretty();   # show records under age 40
db.customers.find({"address.city":"Boston"}); # assuming address is an object with city field

### Foreach
db.customers.find().forEach(function(doc){print("Customer Name: "+doc.first_name)});

__END__
