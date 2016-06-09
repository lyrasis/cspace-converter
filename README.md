cspace-converter
===

Migrate data to CollectionSpace.

Getting Started
---

Ruby (2.x) & Rails are required. The database backend is MongoDB (3.2) and by default should be running on `localhost:27017`.

```
bundle install
```

Setup
---

Create the data directory and add the data files (typically saved as CSV).

**Run MongoDB**

```
# for local development / conversions
docker run --net=host --name mongo -d mongo:3.2
```

**Using the console**

```
rails c
p = ProcedureObject.first
puts p.to_cspace_xml("CollectionObject")
```

License
---

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---