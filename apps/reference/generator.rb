require 'sinatra'
require 'slim'
require 'tilt/redcarpet'
require 'pygments'
require 'nokogiri'

module Reference
  class Generator < Redcarpet::Render::HTML
    def block_code(code, language)
      puts "COOOODE"
      Pygments.highlight(code, lexer: language)
    end

    def header(text, header_level)
      # The header class is temporary - it allows us to iterate over all headers
      # in order with Nokogiri
      %Q{<h#{header_level} class="header">#{text}</h#{header_level}>}
    end

    def postprocess(html)
      doc = Nokogiri::HTML("<!DOCTYPE html>\n<html><body>#{html}</body></html>")

      wrap_headers(doc)
      create_anchors(doc)
      nav_links = create_nav_links(doc)

      doc.css('body').first.children.first.add_previous_sibling(nav_links)

      doc.to_s
    end

    def wrap_headers(doc)
      doc.css('.header').map do |node|
        parent = doc.create_element('section')
        node.add_previous_sibling(parent)

        nodes = Nokogiri::XML::NodeSet.new(doc)
        while next_node = node.next
          break if next_node.name =~ /h\d/
          nodes.push(node)
          node = next_node
        end

        parent.add_child(nodes)
      end
    end

    def create_anchors(doc)
      doc.css('.header').map do |node|
        slug = slugify(node.text)
        anchor = %Q{<a id="#{slug}" class="reference-anchor" href="##{slug}" aria-hidden="true"><span class="reference-link"></span></a>}
        node.prepend_child(anchor)
      end
    end

    # Creates a nav (nested ul) with links to headers
    def create_nav_links(doc)
      result = doc.create_element('ul')
      ul = result
      li = nil
      last_level = 1
      doc.css('.header').map do |node|
        slug = slugify(node.text)
        level = node.name[1..-1].to_i
        delta = level-last_level
        if delta > 0
          delta.times do
            ul = doc.create_element('ul')
            li.add_child(ul)
          end
        end
        if delta < 0
          delta.abs.times do
            ul = ul.parent.parent
          end
        end

        last_level = level

        # TODO: Escape node.text
        li = doc.parse(%Q{<li><a href="##{slug}">#{node.text}</a></li>"}).first
        ul.add_child(li)
      end
      result
    end

    def slugify(string)
      string
        .gsub(/[']+/, '')
        .gsub(/\W+/, ' ')
        .strip
        .downcase
        .gsub(' ', '-')
    end
  end
end
