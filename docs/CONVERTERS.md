# Converters

Converters are a "profile" for mapping data in one or more CSV
documents to CollectionSpace XML payloads.

## How to create a converter

Converters are defined in `lib/collectionspace/converter/`.
This directory containers a `_default/record.rb` file that is the
foundation for converter profiles to build upon. If a procedure
or authority is not represented in `record.rb` it cannot be mapped,
and most likely should be added (pull requests welcome!).

Subfolders in this directory are converter implementations. Each
converter requires a `_config.rb` file to define its behavior.

If you're creating a converter for `mymuseum` you could create
`lib/collectionspace/converter/mymuseum/_config.rb`.

## Converter configuration

Begin by copying the `_default/default.rb` but replace "Default"
with "MyMuseum" (following ruby naming conventions).

```ruby
module CollectionSpace
  module Converter
    module MyMuseum

      def self.registered_procedures
        []
      end

      def self.registered_profiles
        {}
      end

    end
  end
end
```

The converter configuration must implement the two class methods:

### Registered Procedures

This is simply a list of Procedures that this converter can generate
XML records for. It's a handbrake against inadevertently generating
invalid record types.

### Registered Profiles

This is where the bulk of configuration happens. A converter can
implement one or more profiles. You can name these arbitrarily
according to what makes sense for your data. If all of your data
was in a single spreadsheet if may look like:

```ruby
def self.registered_profiles
  {
    "mymuseum" => {}, # ...
  }
end
```

This would indicate a single converter "profile" being used to handle
a **single** CSV document. Note: one profile per CSV file, but one
profile can handle multiple record types per CSV.

If we have multiple CSV files to work with we'll need multiple
"profiles".

```ruby
def self.registered_profiles
  {
    "cataloging" => {}, # ...
    "media" => {}, # ...
  }
end
```

In this case there are distinct CSV files for different procedures
so we need a profile to manage each data file.

Each "profile" needs to define the type of records it generates from
the CSV data. There must be only one top level key:

#### Procedures

Each Procedure to be generated using this profile needs an entry
defining:

- identifier: the field in the source data used for identifier_field
- title: the field in the source data used for the local title

Note: the CSV processor downcases all characters and replaces spaces
with "_". So a field like "ID Number" should be referred to
as "id_number" within the application.

Example:

```ruby
"Procedures" => {
  "Acquisition" => {
    "identifier" => "accession_number",
    "title" => "accession_number",
  },
  "ValuationControl" => {
    "identifier" => "valuation_number",
    "title" => "valuation_number",
  },
},
```

The Procedures configuration can include an "Authorities" key. This refers
to fields within the csv that refer to, and can generate, authority records
directly related to the procedures:

```ruby
"Procedures" => {
  # authorities referenced in the csv
  "Authorities" => {
    "Person" => ["recby", "recfrom"],
  },
},
```

#### Authorities

Each Authority to be generated using this profile needs an entry
defining:

- name_field: field used to generate the authority name / short_id
- authority_type: the primary authority type i.e. Concept, Person etc.
- authority_subtype: the authority subtype i.e. person, ulan_pa, person_shared

Example:

```yml
Authorities:
  Person:
    name_field: termdisplayname
    authority_type: Person
    authority_subtype: person
```

## Running a converter

```bash
./import.sh data/mymuseum/mymuseum_data.csv mymuseum1 mymuseum
```

The arguments correspond to:

- csv name
- batch name (arbitrary)
- converter profile

---
