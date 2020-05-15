# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Extension
      # Social Media Extension
      module SocialMedia
        ::SocialMedia = CollectionSpace::Converter::Extension::SocialMedia
        def self.map_social_media(xml, attributes)
          # socialMediaGroupList, socialMediaGroup
          socialmedia_data = {
            'socialmediahandle' => 'socialMediaHandle',
            'socialmediahandletype' => 'socialMediaHandleType'
          }
          socialmedia_transforms = {
            'socialmediahandletype' => { 'vocab' => 'socialmediatype' }
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
