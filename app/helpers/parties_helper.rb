module PartiesHelper  
  
  def render_current_rating(rating)
    html = ""
    rating.times { html += "<i class='icon-star'></i>" }
    (5 - rating).times { html += "<i class='icon-star-empty'></i>" }
    raw html
  end

  def get_party_comments(party)
    if party.comments.count < 3
      party.comments
    else
      party.comments.skip(party.comments.count - 3)
    end
  end
  
  def render_view_party_comments_link(party)
    if party.comments.count <= 50
      link_to "View #{party.comments.count - 3} previous comments", 
              "/comments?party_id=#{party.id}",
              remote: true,
              id: "more_comments"
    else
      link_to "View previous comments",
              "/comments?party_id=#{party.id}&skip=#{party.comments.count - 50 - 3}",
              remote: true,
              id: "more_comments"
    end
  end
  
end
