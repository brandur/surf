require 'rdiscount'

require 'types/type_utils'

class Article
  include TypeUtils

  def self.read(path, conf)
    articles = []
    article_paths = Dir["#{path}/articles/**/*.md"]
    article_paths.each do |article_path|
      name  = get_name(article_path)
      attrs = read_yaml("#{File.dirname(article_path)}/#{name}.yaml")
      articles.push(Article.new(name, attrs, File.read(article_path), conf))
    end
    articles
  end

  attr_accessor :conf, :content, :created_at, :layout, :location, :name, :permalink, :photos, :tiny, :title, :updated_at

  def initialize(name, attrs, content, conf)
    self.conf         = conf
    self.content      = content
    self.created_at   = attrs['created_at'] ? Time.parse(attrs['created_at']) : Time.now
    self.layout       = attrs['layout'] || 'article'
    self.location     = attrs['location']
    self.name         = name
    self.permalink    = attrs['permalink'] || name
    self.photos       = attrs['photos'] || []
    self.tiny         = attrs['tiny']
    self.title        = attrs['title']
    self.updated_at   = attrs['updated_at'] ? Time.parse(attrs['updated_at']) : self.created_at
  end

  def output_path
    "articles/#{self.permalink}.html"
  end

  def render(locals = nil)
    RDiscount.new(self.content).to_html
  end

  def to_s
    "Article: #{self.name}, title = '#{self.title}', permalink = '#{self.permalink}', published_at = '#{self.published_at}'"
  end

  def uri
    "#{self.conf.uri_prefix}articles/#{self.permalink}"
  end
end
