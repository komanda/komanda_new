class StaticPagesController < ApplicationController
  before_filter :admin_user, only: [:stats]
  
  def contact
  end

  def stats
  	@users = User.all.desc(:name)
  	@events = Party.all.desc(:when)
  	@suggestions = Suggestion.all.desc(:created_at)
  end
end
