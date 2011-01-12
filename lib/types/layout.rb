require 'haml'

require 'helpers'
require 'types/type_utils'

class Layout
  include TypeUtils

  @@context = Object.new.extend(Helpers)

  def self.read(path)
    layouts = {}
    layout_paths = Dir["#{path}/layouts/**/*.haml"]
    layout_paths.each do |layout_path|
      name  = get_name(layout_path)
      attrs = read_yaml("#{File.dirname(layout_path)}/#{name}.yaml")
      layouts[name] = Layout.new(name, attrs, File.read(layout_path))
    end
    layouts
  end

  attr_accessor :engine, :name, :parent

  def initialize(name, attrs, content)
    self.engine = Haml::Engine.new(content)
    self.name   = name
    self.parent = attrs['layout']
  end

  def render(layouts, locals, &block)
    if parent
      layouts[parent].render(layouts, locals) do
        self.engine.render(@@context, locals, &block)
      end
    else
      self.engine.render(@@context, locals, &block)
    end
  end
end

