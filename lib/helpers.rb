module Helpers
  def link_to(entity)
    %Q!<a href="#{entity.uri}" title="#{entity.title}">#{entity.title}</a>!
  end
end
