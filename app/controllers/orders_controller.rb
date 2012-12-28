class OrdersController < ApplicationController
  before_filter :logged_in, only: [:new, :create]
  before_filter :admin_user, only: [:show, :index]
  
  def index
    if params[:party_id]
      @party = Party.find(params[:party_id])
      @users = []
      @party.tickets.each_key do |key|
        @users << User.find(key)
      end
    end
  end

  def new
    if params[:party_id]
      session[:party_id] = params[:party_id]
      party = Party.find(params[:party_id])
      if party.date >= (Date.current() - 8.hour).to_date
        @order = Order.new
        @order.price = party.price
      else
        redirect_to root_path  
      end
    else
      redirect_to root_path
    end
  end

  def create
    @order = current_user.orders.new(params[:order])
    @order.ip_address = request.remote_ip
    
    if session[:party_id]
      party = Party.find(session[:party_id])
      @order.price = party.price
    end
    if @order.save
      if @order.purchase
        if party
          if party.tickets.has_key?("#{current_user.id}")
            party.tickets["#{current_user.id}"] += @order.quantity
          else
            party.tickets["#{current_user.id}"] = @order.quantity
          end
          party.save
        end
        render 'success'
      else
        render 'failure'
      end
    else
      render 'new'
    end
  end
  
  def show
    @order = Order.find(params[:id])
  end
  
  def edit
    @order = current_user.orders.find(params[:id])
    if @order.nil?
      redirect_to root_path
    else
      render 'edit'
    end
  end
  
  def update
    @order = current_user.orders.find(params[:id])
    if @order.nil?
      redirect_to root_path
    else
      if @order.update_attributes(params[:order])
        redirect_to @order
      else
        render 'edit'
      end
    end
  end
end
