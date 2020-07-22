module Hopscotch
  module Serializers
    class JsonSerializer

      def self.encode(message)
        ::JSON.dump(message)
      end

      def self.decode(message)
        ::JSON.parse(message, symbolize_names: true)
      end

      def self.content_type
        'application/json'
      end

    end
  end
end