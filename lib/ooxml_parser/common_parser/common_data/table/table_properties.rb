# Table Properties Data
require_relative 'properties/table_look'
require_relative 'properties/table_style'
require_relative 'properties/table_position'
require_relative 'properties/table_style_properties'
require_relative 'table_properties/table_borders'
module OoxmlParser
  # Class for parsing `w:tblPr` tags
  class TableProperties < OOXMLDocumentObject
    attr_accessor :jc, :table_width, :shd, :table_borders, :table_properties, :table_positon, :table_cell_margin, :table_indent, :stretching, :table_style, :row_banding_size,
                  :column_banding_size, :table_look, :grid_column, :right_to_left, :style

    alias table_properties table_positon

    def initialize(parent: nil)
      @jc = :left
      @table_borders = TableBorders.new
      @parent = parent
    end

    def copy
      table = TableProperties.new
      table.jc = @jc
      table.table_width = @table_width
      table.shd = @shd
      table.stretching = @stretching
      table.table_borders = @table_borders
      table.table_properties = @table_properties
      table.table_cell_margin = @table_cell_margin
      table.table_indent = @table_indent
      table.grid_column = @grid_column
      table.right_to_left = @right_to_left
      table.style = style
      table
    end

    # Parse TableProperties object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [TableProperties] result of parsing
    def parse(node)
      node.xpath('*').each do |node_child|
        case node_child.name
        when 'tableStyleId'
          @style = TableStyle.parse(style_id: node_child.text)
        when 'tblBorders'
          @table_borders = TableBorders.parse(node_child)
        when 'tblStyle'
          @table_style = root_object.document_style_by_id(node_child.attribute('val').value)
        when 'tblW'
          @table_width = node_child.attribute('w').text.to_f / 567.0
        when 'jc'
          @jc = node_child.attribute('val').text.to_sym
        when 'shd'
          unless node_child.attribute('fill').nil?
            background_color = Color.from_int16(node_child.attribute('fill').value)
            @shd = background_color
          end
        when 'tblLook'
          @table_look = TableLook.new(parent: self).parse(node_child)
        when 'tblInd'
          @table_indent = node_child.attribute('w').text.to_f / 567.0
        when 'tblpPr'
          @table_positon = TablePosition.parse(node_child)
        when 'tblCellMar'
          @table_cell_margin = TableMargins.new(parent: table_properties).parse(node_child)
        end
      end
      @table_look = TableLook.new(parent: self).parse(node) if @table_look.nil?
      @right_to_left = option_enabled?(node, 'rtl')
      self
    end
  end
end
