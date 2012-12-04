module ApplicationHelper
  def facebook_like
    content_tag :iframe, 
                nil, 
                :src => "http://www.facebook.com/plugins/like.php?href=#{CGI::escape(request.url)}&layout=standard&show_faces=true&width=450&action=like&font=arial&colorscheme=light&height=80", 
                :scrolling => 'no', 
                :frameborder => '0', 
                :allowtransparency => true, 
                :id => :facebook_like
  end

  def parties_controller?
  	"parties" == params[:controller]
  end

  def suggestions_controller?
  	"suggestions" == params[:controller]
  end

  def shares_controller?
  	"shares" == params[:controller]
  end
end
