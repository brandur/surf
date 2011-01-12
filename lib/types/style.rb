require 'sass'

require 'types/type_utils'

class Style
  include TypeUtils

  def self.read(path, conf)
    styles = []
    style_paths = Dir["#{path}/styles/**/*.sass"]
    style_paths.each do |style_path|
      name  = get_name(style_path)
      attrs = read_yaml("#{File.dirname(style_path)}/#{name}.yaml")
      styles.push(Style.new(name, attrs, File.read(style_path), conf))
    end
    styles
  end

  attr_accessor :conf, :content, :layout, :name, :permalink

  def initialize(name, attrs, content, conf)
    self.conf      = conf
    self.content   = content
    self.layout    = nil
    self.name      = name
    self.permalink = attrs['permalink'] || "#{name}.css"
  end

  def output_path
    "assets/styles/#{self.permalink}"
  end

  def render(locals)
    Sass::Engine.new(self.content).render
  end

  def to_s
    "style: #{self.name}, permalink = '#{self.permalink}'"
  end

  def uri
    "#{self.conf.uri_prefix}assets/styles/#{self.permalink}"
  end
end

