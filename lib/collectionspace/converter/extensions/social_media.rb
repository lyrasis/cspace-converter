module CollectionSpace
  module Converter
    module Extensions
      module SocialMedia
          ::SocialMedia = CollectionSpace::Converter::Extensions::SocialMedia
          def self.map_social_media(xml, attributes)
            #socialMediaGroupList, socialMediaGroup
            socialmedia_data = {
              "socialmediahandle" => "socialMediaHandle",
              "socialmediahandletype" => "socialMediaHandleType",
            }
            socialmedia_transforms = {
              'socialmediahandletype' => {'vocab' => 'socialmediatype'}
            }
            CSXML.add_single_level_group_list(
              xml,
              attributes,
              'socialMedia',
              socialmedia_data,
              socialmedia_transforms
            )
          end
          
        end
      end
    end
  end
