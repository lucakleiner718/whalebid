class CasinosController < ApplicationController
  
  before_action :get_markets, only: [:index, :show]
  def index
    @casinos = Casino.order("lower(casino_name)")
    if params[:market] && params[:market] != 'all' && params[:market] !=''
      @casinos = @casinos.where('casino_market = ?', params[:market])
    end

    if params[:query] && params[:query] != 'all' && params[:query] !=''
      @casinos = @casinos.where('casino_name like ?', '%' + params[:query] + '%')
    end

  end
  
  def new
    @casino = Casino.new
  end

  def create
    @casino = Casino.new(casino_params) 
    if @casino.save
      flash[:notice] = "A new record for '#{@casino.casino_name}' was created successfully."
      redirect_to(action: 'index')
    else
      render('new')
    end
  end

  def show
    @casino = Casino.find(params[:id])
  end

  def edit
    @casino = Casino.find(params[:id])
  end
  
  def update
    @casino = Casino.find(params[:id])
    if @casino.update_attributes(casino_params)
      flash[:notice] = "The record for '#{@casino.casino_name}' was updated successfully."
      redirect_to(action: 'show', id: @casino.id)
    else
      render('edit')
    end 
  end

  def delete
    @casino = Casino.find(params[:id])
  end
  
  def destroy
    casino = Casino.find(params[:id]).destroy
    flash[:notice] = "The record for '#{casino.casino_name}' was destroyed successfully."
    redirect_to(action:'index')
  end
  
  def casino_params
    params.require(:casino).permit(:casino_name, :city, :state, :postal_code, :country, :casino_market)
  end
  
end
