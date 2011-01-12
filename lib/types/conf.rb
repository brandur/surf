require 'types/type_utils'

class Conf
  include TypeUtils

  def self.read(path)
    Conf.new(read_yaml("#{path}/conf.yaml"))
  end

  attr_accessor :output_dir, :uri_prefix

  def initialize(attrs)
    self.output_dir = attrs['output_dir']
    self.uri_prefix = attrs['uri_prefix'] || '/'
  end
end
