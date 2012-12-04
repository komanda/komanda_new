class PartiesController < ApplicationController
  before_filter :admin_user, only: [:create, :update, :destroy]
  before_filter :logged_in, only: [:rate, :join, :unjoin]
  # GET /parties
  # GET /parties.json
  def index
    @today = Time.now
     
    if params[:sidebar]
      @sidebar = true
      @skip = params[:skip].to_i
      @parties = Party.desc(:when).skip(@skip).limit(5).to_a
      @prev = Party.find(params[:prev])
      @skip += 5
      @done = Party.all.count <= @skip ? true : false

      if params[:extra]
        @extra = params[:extra]
        @parties.delete(Party.find(@extra))
      end

    elsif params[:skip]
      @skip = params[:skip].to_i
      @previous = Party.where(:when.lt => @today).skip(@skip).desc(:when).limit(4)
      @skip += 4
      @done = Party.where(:when.lt => @today).count <= @skip ? true : false
    else  
      @previous = Party.where(:when.lt => @today).desc(:when).limit(4)
      @upcoming = Party.where(:when.gt => @today).desc(:when)
      @suggestions = Suggestion.skip(@skip).limit(3).order_by(:vote_counter.desc, :comment_counter.desc, :created_at.desc)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  end

  # GET /parties/1
  # GET /parties/1.json
  def show
    if params[:prev]
      @prev = Party.find(params[:prev])
    elsif params[:modal]
      @modal = true
    end

    @party = Party.find(params[:id])
    @party.inc(:views, 1)

    unless @prev || @modal  
      today = Time.now
      @upcoming = Party.where(:when.gte => today).desc(:when)
      @previous = Party.where(:when.lt => today).desc(:when).limit(4)
      # @parties = Party.all.desc(:when).limit(5).to_a

      unless @upcoming.include?(@party) || @previous.include?(@party)
        if @party.when > today
          @upcoming << @party
        else
          @previous << @party
        end
        @extra = @party.id  
      end
      
    end


    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /parties/new
  # GET /parties/new.json
  def new
    admin_user
    @party = Party.new
  end

  # GET /parties/1/edit
  def edit
    admin_user
    @party = Party.find(params[:id])
  end

  # POST /parties
  # POST /parties.json
  def create
    @party = Party.new(params[:party])
    @party.pics = (params[:party][:pics]).split

    respond_to do |format|
      if @party.save
        format.html { redirect_to @party, notice: 'Party was successfully created.' }
        format.json { render json: @party, status: :created, location: @party }
      else
        format.html { render action: "new" }
        format.json { render json: @party.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parties/1
  # PUT /parties/1.json
  def update
    @party = Party.find(params[:id])
    @party.assign_attributes(params[:party])
    @party.pics = (params[:party][:pics]).split

    respond_to do |format|
      if @party.save
        format.html { redirect_to @party, notice: 'Party was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @party.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parties/1
  # DELETE /parties/1.json
  def destroy
    @party = Party.find(params[:id])
    @party.destroy

    respond_to do |format|
      format.html { redirect_to parties_url }
      format.json { head :no_content }
    end
  end

  def rate
    if current_user.id.to_s == params[:user]
      @rating = params[:rating]

      @party = Party.find(params[:party])
      @party.ratings["#{current_user.id}"] = @rating
      @party.save

      @user = User.find(params[:user])
      @user.ratings["#{@party.id}"] = @rating
      @user.save
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end  
  end

  def join
    @party = Party.find(params[:party])
    @party.going << current_user.id unless @party.going.include?(current_user.id)
    @party.save

    respond_to do |format|
      format.js
    end
  end
end
