require 'term/ansicolor'

require 'types/article'
require 'types/conf'
require 'types/layout'
require 'types/page'
require 'types/style'

class Compiler
  C = Term::ANSIColor

  def initialize(path)
    @path = path
  end

  def run
    @conf = Conf.read(@path)
    puts "Loading site data ..."
    @layouts  = Layout.read(@path)
    @pages    = Page.read(@path, @conf)
    @articles = Article.read(@path, @conf)
    @styles   = Style.read(@path, @conf)
    puts "Compiling site ..."
    FileUtils.mkdir_p "#{@conf.output_dir}/articles/"
    FileUtils.mkdir_p "#{@conf.output_dir}/assets/styles/"
    FileUtils.ln_sf File.absolute_path("#{@path}/images/"), "#{@conf.output_dir}/assets/"
    write_items([].concat(@articles).concat(@pages).concat(@styles))
  end

  private

  def write_items(items)
    items.each do |item|
      path = "#{@conf.output_dir}/#{item.output_path}"
      locals = {
        :articles => @articles, 
        :conf     => @conf, 
        :pages    => @pages, 
        :styles   => @styles
      }
      locals[:item] = item
      if item.layout && item.layout != 'none'
        content = @layouts[item.layout].render(@layouts, locals) do
          item.render(locals)
        end
      else
        content = item.render(locals)
      end
      if !File.exists?(path) || File.read(path) != content
        File.open(path, 'w') { |f| f.puts(content) }
        puts "#{C.bold { C.green { 'write' }}} #{path}"
      else
        puts "#{C.bold { 'identical' }} #{path}"
      end
    end
  end
end

