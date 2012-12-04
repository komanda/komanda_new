class SharesController < ApplicationController
   before_filter :admin_user, only: :destroy

   def index
      share_limit = 50

      @share = Share.new      
      @skip = params[:skip].nil? ? 0 : params[:skip].to_i

      @shares = Share.all.desc(:created_at).skip(@skip).limit(share_limit)

      @skip += share_limit
      @done = @skip >= Share.count ? true : false

      respond_to do |format|
         format.html
         format.js
      end
   end

   def create

      unless spam?   
         @share = current_user.shares.create(params[:share])

         respond_to do |format|
            format.js
         end
      end
   end

   def destroy
      @share = Share.find(params[:id])
      @share.destroy unless @share.nil?

      respond_to do |format|
         format.js
      end
   end

   private
      
      def spam?
         time = Time.now

         count = current_user.shares.count
         if count >= 2
            if time - current_user.shares[count - 2].created_at < 3.seconds
               return true
            end
         end
         
         return false
      end
end
