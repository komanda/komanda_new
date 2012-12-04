module SuggestionsHelper
  
  def get_comments_for_suggestion(suggestion)
    if suggestion.comments.count <= 3
      comments = suggestion.comments
    else
      comments = suggestion.comments.skip(suggestion.comments.count - 3)
    end
  end
  
  def render_view_suggestion_comments_link(suggestion)
    if suggestion.comments.count > 3
      
      if suggestion.comments.count <= 50
        link_to "View #{suggestion.comments.count - 3} previous comments", 
                "/comments?suggestion_id=#{suggestion.id}",
                remote: true,
                id: "load_more_comments_#{suggestion.id}",
                class: "visible-desktop"
      else
        link_to "View previous comments",
                "/comments?suggestion_id=#{suggestion.id}&skip=#{suggestion.comments.count - 50 - 3}",
                remote: true,
                id: "load_more_comments_#{suggestion.id}",
                class: "visible-desktop"
      end
    end
  end
end
