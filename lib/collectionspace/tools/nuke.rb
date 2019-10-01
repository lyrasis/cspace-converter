module CollectionSpace
  module Tools
    class Nuke
      def self.everything!
        [
          Batch,
          CacheObject,
          CollectionSpaceObject,
          DataObject,
          Delayed::Job,
        ].each { |model| model.destroy_all }
      end
    end
  end
end
