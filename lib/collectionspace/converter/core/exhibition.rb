module CollectionSpace
  module Converter
    module Core
      class CoreExhibition < Exhibition
        ::CoreExhibition = CollectionSpace::Converter::Core::CoreExhibition
        def convert
          run do |xml|
            CoreExhibition.map(xml, attributes)
          end
        end

        def self.pairs
          {
            'exhibitionnumber' => 'exhibitionNumber',
            'title' => 'title',
            'type' => 'type',
          }
        end

        def self.simple_groups
          {
          }
        end

        def self.simple_repeats
          {
          }
        end

        def self.simple_repeat_lists
          {
          }
        end

        def self.map(xml, attributes)
          CSXML::Helpers.add_pairs(xml, attributes, CoreExhibition.pairs)
=begin
          CSXML::Helpers.add_simple_groups(xml, attributes, CoreExhibition.simple_groups)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreExhibition.simple_repeats)
          CSXML::Helpers.add_simple_repeats(xml, attributes, CoreExhibition.simple_repeat_lists, 'List')
=end
#CSXML.add xml, 'type', CSXML::Helpers.get_vocab('exhibitiontype', attributes['type'])

=begin
This is what Paul had: (delete after comparing/testing)

          overallvenue = {
            'venueorganization' => 'venue',
            'venueopeningdate' => 'venueOpeningDate'
          }
          CSXML.add_group_list(
            xml,
            attributes,
            'venue',
            overallvenue,
            group_suffix: 'Group'
)

^-- Paul, one main reason this wasn't working is, you were calling `add_group_list` with attributes as the 2nd
       parameter.
    As you can see at the definition of `add_group_list` the second parameter should be the 'topKey', or string used
       as the base of the fieldGroupList and fieldGroup field names
    https://github.com/collectionspace/cspace-converter/blob/master/lib/collectionspace/tools/xml.rb#L100-L106

Then the other parameters aren't in the right place either
If you just removed the attributes parameter, there would be errors because `overallvenue` has not been transformed
into the array of data hashes required by the `elements` argument:
https://github.com/collectionspace/cspace-converter/blob/master/lib/collectionspace/tools/xml.rb#L40

In general, I think it's best to avoid calling `add_group_list` directly going forward. Instead, we have helper functions like: 
- add_nested_group_lists
- prep_and_add_single_level_group_list
- add_group_list_with_structured_date


Possible result example:

<venueGroupList>
  <venueGroup>
    <venue>urn:cspace:core.collectionspace.org:orgauthorities:name(organization):item:name(OaklandMuseumofCalifornia1579006073282)'Oakland Museum of California'</venue>
    <venueOpeningDate>2000-01-02T00:00:00.000Z</venueOpeningDate>
    <venueUrl>https://lyrasis.org</venueUrl>
    <venueAttendance>456</venueAttendance>
    <venueClosingDate>2000-02-02T00:00:00.000Z</venueClosingDate>
  </venueGroup>
  <venueGroup>
    <venue>urn:cspace:core.collectionspace.org:placeauthorities:name(place):item:name(England1574126154718)'England'</venue>
    <venueOpeningDate>2019-01-09T00:00:00.000Z</venueOpeningDate>
    <venueUrl>https://englandmuseum.org</venueUrl>
    <venueAttendance>789</venueAttendance>
    <venueClosingDate>2019-11-06T00:00:00.000Z</venueClosingDate>
  </venueGroup>
  <venueGroup>
    <venue>urn:cspace:core.collectionspace.org:locationauthorities:name(location):item:name(BuildingA1578522169466)'Building A'</venue>
    <venueOpeningDate>2019-08-12T00:00:00.000Z</venueOpeningDate>
    <venueUrl>https://ourmuseum.org</venueUrl>
    <venueAttendance>111</venueAttendance>
    <venueClosingDate>2019-09-20T00:00:00.000Z</venueClosingDate>
  </venueGroup>
</venueGroupList>

Here is the pattern for how to handle this. You can remove the detailed commenting once it is no longer needed:

The first hash I create maps the spreadsheet columns/'attributes' (left side) to the target CSpace fields (right side)
=end

venuedata = {
  'venueorganization' => 'venue',
  'venueplace' => 'venue',
  'venuestoragelocation' => 'venue',
  'venueopeningdate' => 'venueOpeningDate',
  'venueclosingdate' => 'venueClosingDate',
  'venueattendance' => 'venueAttendance',
  'venueurl' => 'venueUrl'
}

# This hash specifies how the data from each column of the spreadsheet should be transformed
#  before populating the CSpace field
# The format of this is documented here:
#  https://github.com/collectionspace/cspace-converter/wiki/CSXML.apply_transforms-method
venuetransforms = {
  #sampledatacolumn => {transformType=authority => [authorityType, authorityName]}
  'venueorganization' => {'authority' => ['orgauthorities', 'organization']},
  'venueplace' => {'authority' => ['placeauthorities', 'place']},
  'venuestoragelocation' => {'authority' => ['locationauthorities', 'location']},
  #sampledatacolumn => {special transformation to unstructured date}
  # NOTE that depending on Mark's answer here, the transformation required here may need to change:
  #  https://github.com/collectionspace/cspace-converter/issues/175
  'venueopeningdate' => {'special' => 'unstructured_date'},
  'venueclosingdate' => {'special' => 'unstructured_date'},
}

# The following handles getting the data from the CSV,
# splitting the fields, verifying even number of values across fields,
# flattening into an array of data hashes, applying the transformations,
# and calling add_group_list using the results

CSXML.prep_and_add_single_level_group_list(
  xml, attributes,
  'venue', # the base name for the fieldGroupList
  venuedata, 
  venuetransforms
  # The default list_suffix and group_suffix values defined at
  #  https://github.com/collectionspace/cspace-converter/blob/master/lib/collectionspace/tools/xml.rb#L163-L164
  # will be used to create the enclosing <venueGroupList> and <venueGroup> fields, so they do not need to be
  # specified here
)
        end
      end
    end
  end
end
