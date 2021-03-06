require 'spec_helper'

describe OoxmlParser::Shade do
  it 'shade should be able to have all arguments set by constructor' do
    expect(OoxmlParser::Shade.new(color: :auto,
                                  value: :clear,
                                  fill: OoxmlParser::Color.new(127, 127, 127))).to be_a(OoxmlParser::Shade)
  end

  it 'should do something' do
    docx = OoxmlParser::DocxParser.parse_docx('spec/document/elements/paragraph/runs/properties/shade/shade_clear.docx')
    expect(docx.elements.first.nonempty_runs[1].run_properties.shade.value).to eq(:clear)
    expect(docx.elements.first.nonempty_runs[1].run_properties.shade.color).to eq(:auto)
    expect(docx.elements.first.nonempty_runs[1].run_properties.shade.fill).to eq(OoxmlParser::Color.new(0, 255, 0))
  end
end
