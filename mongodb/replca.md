# replset

## start some node

mongod --replSet ecole --host 172.16.1.1 --port 2811
mongod --replSet ecole --host 172.16.1.3 --port 2812  
mongod --replSet ecole --host 172.16.1.3 --port 2813  

## in main node, execute following operations


```ruby
mongo 

db>cfg = {  
   _id : 'ecole',  
   members : [  
     { _id : 0, host : '172.16.1.1:27017', priority : 4 },  
     { _id : 1, host : '172.16.1.2:27017', priority : 2 },  
     { _id : 2, host : '172.16.1.3:27017', priority : 1, votes : 0 }  
   ]  
};  

db>rs.initialize(cfg);
```

## dynamicly add new node

1. start new node

	mongod --replSet ecole --host 172.16.1.4 --port 27017 

1. in main node

	rs.add("newnode:27017");
