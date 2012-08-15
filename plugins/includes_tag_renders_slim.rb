module Jekyll
  require 'slim'
  require 'pathname'
  class IncludeTag < Liquid::Tag

    def render(context)
      includes_dir = File.join(context.registers[:site].source, '_includes')

      if File.symlink?(includes_dir)
        return "Includes directory '#{includes_dir}' cannot be a symlink"
      end

      if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
        return "Include file '#{@file}' contains invalid characters or sequences"
      end

      Dir.chdir(includes_dir) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@file)
          source = File.read(@file)
          if Pathname.new(@file).extname =~ /slim/i
            puts "Rendering... " + Pathname.new(@file).basename.to_s
            slim = Tilt.new(@file).render
            partial = Liquid::Template.parse(slim)
          else
            partial = Liquid::Template.parse(source)
          end
          context.stack do
            partial.render(context)
          end
        else
          "Included file '#{@file}' not found in _includes directory"
        end
      end
    end
  end

end
