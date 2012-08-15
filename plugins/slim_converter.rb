module Jekyll
  require 'slim'
  class SlimConverter < Converter
    safe true
    priority :high

    def matches(ext)
      ext =~ /slim/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      begin
        Slim::Template.new { content }.render
      rescue StandardError => e
        puts "!!! SLIM Error: " + e.message
      end
    end
  end
end
