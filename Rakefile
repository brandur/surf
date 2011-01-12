require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require 'active_support/core_ext'
require 'compiler'

desc "Compile content"
task :compile do
  Compiler.new('.').run
end

namespace :create do
  desc "Creates a new article"
  task :article do
    def calc_path(title)
      slug = title.parameterize('-')
      path = "#{File.dirname(__FILE__)}/articles/"
      [ title.titleize, slug, "#{path}#{slug}.md", "#{path}#{slug}.yaml" ]
    end

    if !ENV['title']
      $stderr.puts "\t[error] Missing title argument.\n\tusage: rake create:article title='article title'"
      exit 1
    end

    title, slug, md, yaml = calc_path(ENV['title'])

    yaml_template = <<TEMPLATE
title: "#{title}"
created_at: #{Time.now.strftime("%B %d, %Y %k:%M")}
location: Calgary
tiny: a/#{title.split(/ /).first.strip.downcase.gsub(/[^A-Za-z0-9]/, '')}
TEMPLATE

    File.open(md, 'w') { |f| f.write('') }
    File.open(yaml, 'w') { |f| f.write(yaml_template) }
    $stdout.puts "\t[ok] Edit #{md}"
    `ln -f -s #{md} current_article`
    `ln -f -s #{yaml} current_article.yaml`
  end
end


