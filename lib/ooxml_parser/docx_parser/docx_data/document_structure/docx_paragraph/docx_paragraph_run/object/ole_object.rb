module OoxmlParser
  # Class for parsing `o:OLEObject` tags
  class OleObject < OOXMLDocumentObject
    # @return [String] id of ole_object
    attr_accessor :id
    # @return [FileReference] data referenced in object
    attr_accessor :file_reference

    # Parse OleObject object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [OleObject] result of parsing
    def parse(node)
      node.attributes.each do |key, value|
        case key
        when 'id'
          @id = value.value
        end
      end
      @file_reference = FileReference.parse(node)
      self
    end
  end
end
