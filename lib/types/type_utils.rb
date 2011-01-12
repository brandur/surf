require 'yaml'

module TypeUtils
  module ClassMethods
    def get_name(path)
      File.basename(path, File.extname(path))
    end

    def read_yaml(path)
      if (File.exists?(path))
        File.open(path) { |f| YAML::load(f) }
      else
        {}
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end
end
