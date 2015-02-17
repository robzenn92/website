require_relative '../generator'
require 'nokogiri'

XSL = Nokogiri::XSLT(IO.read(File.dirname(__FILE__) + '/pretty.xsl'))

module Reference
  describe Generator do
    it "creates a TOC" do
      markdown = Redcarpet::Markdown.new(Generator.new)

      md = <<-EOF
# This is a H1

Hello

## That's a H2

World

# Another H1

Hello
EOF

      html = markdown.render(md)
      doc = Nokogiri::HTML(html)
      puts XSL.apply_to(doc).to_s
    end

    it "assigns correct css class for code" do
      markdown = Redcarpet::Markdown.new(Generator.new, fenced_code_blocks: true)

      md = <<-EOF
# This is a H1

```ruby
def hello
end
```
EOF

      html = markdown.render(md)
      doc = Nokogiri::HTML(html)
      puts XSL.apply_to(doc).to_s
    end
  end
end
