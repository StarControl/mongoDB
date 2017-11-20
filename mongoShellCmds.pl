### MongoDB Shell Commands (case-sensitive) ###
blah blah
db # show current db

# Users
db.createUser({user:"Jose", pwd:"1234",roles: [ "readWrite", "dbAdmin" ]});
show users

# Database
use <name of db>  # switch to db.  if doesn't exist, creates & switches to it
show dbs
db.dropDatabase()   # delete current database

# Collections
db.createCollection('customers');
show collections

# Temporary variables
a={first_name:"Albert", last_name:"Einstein"} # variables are not remembered from one db session to another
db.customers.save(a)
db.customers.remove(a)

# Handy shorthand
coll = db.customers   
coll.find()

#-------------------------------------------------------------------------------------------------
# find( <query> , <projection>)  <projection> is optional 
#-------------------------------------------------------------------------------------------------
# Find all documents matching the <query> criteria
# If <projection> is provided, return just specific fields in the <projection> from the matches
db.customers.find()
db.customers.find({last_name:"Luke"},{first_name:true})  # return first_name of all entires matching last_name
db.customers.find().pretty();
db.mycollection.find({ "price" : { "$exists" : false } })  # find all docs without "price" field
# findOne( <query> )  Same as find(<query>).limit(1)

#-------------------------------------------------------------------------------------------------
# Chaining with sort(), count(), skip(), limit(), pretty(), etc
#-------------------------------------------------------------------------------------------------
# count()
# pretty()  Pretty formatting
# skip(n)   Skip n results, n >= 0
# sort(n)   n=1 ascending, n=-1 descending
db.customers.find().sort({last_name:1}).pretty();  
# limit(n)  Limit to n results, n >= 0
coll.find().limit(5)

#-------------------------------------------------------------------------------------------------
# insert( <document> )  
#-------------------------------------------------------------------------------------------------
# Similar to save(), see below.
db.customers.insert({first_name:"John", last_name:"Doe", age:"30"});
coll.insert( {_id:ObjectId("59c48c2085b2e4112d19a6b4") , name:"Jack"} )  # do only if key is unique 

#-------------------------------------------------------------------------------------------------
# save( <document> )
#-------------------------------------------------------------------------------------------------
# Same as insert(), except when an _id field is provided in <document>
# When _id is provided: 
#     save() inserts <document> if _id isn't a duplicate, otherwise does nothing.
#     insert() inserts <document> if _id isn't a duplicate, otherwise displays errmsg 
coll.save( {_id:ObjectId("59c48c2085b2e4112d19a6b4") , name:"Jack"} )  # safe even if key is duplicate 

#-------------------------------------------------------------------------------------------------
# update (to REPLACE an entire document) 
#-------------------------------------------------------------------------------------------------
# update( <query> , <update> )  where <update> is a document to replace the match
# If there is a match using <query>, then the first document matching will be replaced by <update>
# If there is no match, does nothing
#
# update(<query>,<update>, { upsert: boolean, multi: boolean } )
# Upsert 
# If there is a match using <query>, then the first document matching will be replaced by <update>
# If there is no match, then <update> will be inserted.  (note: if the same command is run multiple 
# times without match, addition idential looking documents will be inserted, each with unique _id)
  db.customers.update({first_name:"Mary"},{first_name:"Mary",last_name:"Samson"},{upsert: true});  
# Multi - update multiple docs that match

#-------------------------------------------------------------------------------------------------
# update (to MODIFY/create fields) 
#-------------------------------------------------------------------------------------------------
# update(<query>,<update>) where <update> uses "update operators": $inc, $set, etc.
# In this scenario, <update> must contain only update operators.
# If there is a match, the specified fields are updated if they exist.  If the matched doc does not 
# have those fields, those fields are inserted with the specified values.
# When there is no match, does nothing.
# Can be combined with upsert. In this case, if there is document matching <query>, a new document 
# is inserted which contains both <query> and the specified field and value.  

# $set
  db.costumers.update( {first_name:"John"} , {$set:{last_name:"Denver"}} );  

# $inc
  db.costumers.update( {first_name:"John"} , {$inc:{age:5}});

# $unset
  db.customers.update( {first_name:"John"} , {$unset:{age:true}});  # delete age field

# Others: $min, $max, $rename

# $setOnInsert is another "update operator" but with different behavior
# if there is a match and the specified field exists (whether or not the field value matches), it does nothing 
# if there is no match, does nothing
# Only if the FIRST matching document does not have the specified field does the field get inserted 
# with the specified value.
  db.customers.update( {first_name:"John"} , {$setOnInsert:{last_name:"Denver"}} );  

#-------------------------------------------------------------------------------------------------
# remove 
#-------------------------------------------------------------------------------------------------
  db.customers.remove({first_name:"John"}); # deletes ALL matches
  db.customers.remove({first_name:"John"},{justOne:true}); # deletes first match found

#-------------------------------------------------------------------------------------------------
# Other commands/examples
#-------------------------------------------------------------------------------------------------
  db.customers.find({$or:[{first_name:"John"},{first_name:"Sharon"}]});   # find records matching either names
  db.customers.find({age:{$lt:40}}).pretty();   # show records under age 40

# Accessing field within an object
  db.customers.find({"address.city":"Boston"}); # assuming address is an object with city field

# forEach
  db.customers.find().forEach(function(doc){print("Customer Name: "+doc.first_name)});

  __END__
