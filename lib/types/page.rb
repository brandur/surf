require 'haml'

require 'types/type_utils'

class Page
  include TypeUtils

  @@context = Object.new.extend(Helpers)

  def self.read(path, conf)
    pages = []
    page_paths = Dir["#{path}/pages/**/*.haml"]
    page_paths.each do |page_path|
      name  = get_name(page_path)
      attrs = read_yaml("#{File.dirname(page_path)}/#{name}.yaml")
      pages.push(Page.new(name, attrs, File.read(page_path), conf))
    end
    pages
  end

  attr_accessor :conf, :content, :layout, :name, :permalink, :title

  def initialize(name, attrs, content, conf)
    self.conf         = conf
    self.content      = content
    self.layout       = attrs['layout'] || 'default'
    self.name         = name
    self.permalink    = attrs['permalink'] || name
    self.title        = attrs['title']
  end

  def output_path
    # Nasty way of handling the special index file case
    self.permalink && !self.permalink.empty? ? self.permalink : self.name
  end

  def render(locals)
    Haml::Engine.new(self.content).render(@@context, locals)
  end

  def to_s
    "Page: #{self.name}, title = '#{self.title}', permalink = '#{self.permalink}'"
  end

  def uri
    "#{self.conf.uri_prefix}#{self.permalink}"
  end
end

