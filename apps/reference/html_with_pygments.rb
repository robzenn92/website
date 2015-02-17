require 'sinatra'
require 'slim'
require 'tilt/redcarpet'
require 'pygments'

module Reference
  class HTMLwithPygments < Redcarpet::Render::HTML
    def initialize
      super(with_toc_data: true)
    end

    def block_code(code, language)
      html = Pygments.highlight(code, lexer: language)
      classes = language == 'gherkin' ? language : "toggle #{language}"
      html.gsub(/<div class="highlight">/, %Q{<div class="highlight #{classes}">})
    end

    def postprocess(doc)
      wrap_code = true
      lines = doc.split("\n")
      header_prefix = %Q{\n<div class="topic">\n  <div class="topic-section">\n    <div class="topic-description">\n}
      lines.each do |line|
        if line =~ /^<div class="highlight toggle \w+">/ && wrap_code
          line.prepend(%Q{\n  </div>\n  <div class="topic-example">\n})
          wrap_code = false
        end
        if line =~ /^<h[1-4] id="\w+">([^<]+)<\/h[1-4]*>/
          puts line
          line.prepend(header_prefix)
          header_prefix = %Q{\n    </div>\n  </div>\n</div>\n<div class="topic">\n  <div class="topic-section">\n    <div class="topic-description">\n}
          wrap_code = true
        end
      end
      lines.push("\n    </div>\n  </div>\n</div>\n")
      lines.join("\n")
    end
  end
end
