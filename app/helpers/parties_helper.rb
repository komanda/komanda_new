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
  
  def get_thumb_url(url)
    # http://imageshack.us/a/img717/8971/image7xd.jpg - URL
    # http://imageshack.us/scaled/thumbx2/717/image7xd.jpg - thumb
    if (url.include?("/scaled/"))
      tokens = url.split("/")
      tokens[4] = "thumbx2"
      return tokens.join("/")
    else  
      tokens = url.split("/")
      return "http://imageshack.us/scaled/thumbx2/#{tokens[4].slice(3, tokens[4].length)}/#{tokens[6]}"
    end
  end
end
