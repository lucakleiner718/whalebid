class BidsController < ApplicationController
  
  before_action :get_markets

  def index
    @bids = Bid.all
  end

  def new
    @bid = Bid.first :conditions => ["user_id = ? and (status = ? or status = ? or status = ?)", current_user.id, "Active", "Accepted", "Responed"]
    if not @bid.nil? # and @bid.offers.where('offer_status is null or offer_status != ?','Declined by casino').count == 0
      flash[:notice_type] = "danger"
      flash[:notice] = "*You currently have a bid with offers awaiting your response. You can not create a new bid until you cancel your open bid or accept a offer.<br/>
                        Would you like to manage your offers? <a href='#{current_bids_path}'>Yes</a> / <a href='#{history_bids_path}'>No</a>"
      # redirect_to(action: 'history')
    else
      @bid = Bid.new
    end
    @casinos = Casino.find :all, :conditions => ["users.status = ?", 'active'], :include => :user
  end

  def browse_markets
    if params[:casino_id]
      @casino = Casino.find(params[:casino_id])
      render "markets_casino_details"
    else

      @casinos = Casino.order("lower(casino_name)")
      if params[:market] && params[:market] != 'all' && params[:market] !=''
        @casinos = @casinos.where('casino_market = ?', params[:market])
      end

      if params[:query] && params[:query] != 'all' && params[:query] !=''
        @casinos = @casinos.where('casino_name like ?', '%' + params[:query] + '%')
      end
    end
  end

  def browse_casinos
    if params[:casino_id]
      @casino = Casino.find(params[:casino_id])
      render "casinos_casino_details"
    else
      @casinos = Casino.order("lower(casino_name)")
      if params[:market] && params[:market] != 'all' && params[:market] !=''
        @casinos = @casinos.where('casino_market = ?', params[:market])
      end

      if params[:query] && params[:query] != 'all' && params[:query] !=''
        @casinos = @casinos.where('casino_name like ?', '%' + params[:query] + '%')
      end
    end
  end
  
  def create
    @bid = Bid.new(bid_params)
    if @bid.by_market
      Casino.where("casino_market=?", @bid.market).each do |casino|
        @bid.casinos << casino
      end
    else
      params[:casinos].each do |casino_id|
        if casino_id != ""
          @bid.casinos << Casino.find(casino_id.to_i)
        end
      end
    end

    @casinos = Casino.find :all, :conditions => ["users.status = ?", 'active'], :include => :user
    if @bid.save
      flash[:notice] = "Well done. You have successfully created a new bid."
      redirect_to(action: 'current')
    else
      render('new')
    end  
  end

  def show
    @bid = Bid.find(params[:id])
    if params[:type] == "casino"
      @offer = Offer.new
      render('show4casino')
    else
      render('show4player')
    end
  end

  def current
    @bid = Bid.where('user_id = ? and status in (?)', current_user.id, %w[Active Accepted Responsed]).first
    # @bid = Bid.includes(:offers).where('user_id = ? and status in (?) and (offers.offer_status is NULL or offers.offer_status != ?)', current_user.id, %w[Active Accepted Responsed],'Declined by casino')
    # @bid = @bid.first if @bid.present?
    # puts "**************************", @bid.inspect
    if @bid.nil?
      flash[:notice] = "No open bid. Please create new bid now!"
      redirect_to(action: 'new')
    else
        # if @bid.offers.where('offer_status=?','Declined by casino').count > 0
        #   flash[:notice] = "No open bid. Please create new bid now!"
        #   redirect_to(action: 'new')
        # end
    end
  end

  def history
    @bids = Bid.find :all, :conditions => ["user_id = ?", current_user.id]
  end

  def cancel
    @bid = Bid.find(params[:id])
    @bid.status = "Closed"
    @bid.save

    @bid.offers.where("offer_status is null or offer_status != ?", 'Declined by casino').each do |offer|
      offer.offer_status = "Declined"
      offer.save
    end
    flash[:notice] = "Your bid was successfully cancelled!"
    redirect_to(action: 'history')
  end

  def show_perks
    render layout: 'dialog'
  end

  def casino_bids
    @casino = current_user.casino
    @open_bids = []
    @closed_bids = []

    @casino.bids.each do |bid|
      if bid.status == "Active"
        @open_bids << bid if bid.offers.where("casino_id=? and (offer_status is null or offer_status!=?)", @casino.id, "Declined by casino").count == 0
      else
        if bid.offers.where("casino_id=? and offer_status!=?", @casino.id, "Declined by casino").count > 0
          # TODO : open_bids
        else
          @closed_bids << bid
        end
      end

      @closed_bids << bid if bid.offers.where("casino_id=? and offer_status=?", @casino.id, "Declined by casino").count == 1
    end

  end

  def decline
    @offer = Offer.new
    @offer.bid = Bid.find(params[:id])
    @offer.casino = current_user.casino
    @offer.update_attributes(:offer_status=> "Declined by casino")
    if @offer.save
      flash[:notice] = "You have successfully declined this bid."
      redirect_to(action: 'casino_bids')
    else
    end

  end
  
  def update
    @bid = Bid.find(params[:id])
    if @bid.update_attributes(bid_params)
      flash[:notice] = "Bid for arrival date of '#{@bid.arrival_date}' was updated successfully."
      redirect_to(action: 'show', id: @bid.id)
    else
      render('edit')
    end 
  end
  
  def delete
    @bid = Bid.find(params[:id])
  end
  
  def destroy
    bid = Bid.find(params[:id]).destroy
    flash[:notice] = "Bid for arrival date of '#{bid.arrival_date}' destroyed successfully."
    redirect_to(action:'index')
  end
  
  
  def bid_params
    params.require(:bid).permit(:bid_name, :market,:casino1, :casino2, :casino3, :casino4, :casino5, :by_market, :user_id,
                                :arrival_date, :departure_date, :adults, :children, :wager_level, :bid_fee_reimbursement, :player_category, :bid_fee, 
                                :preference_accomodations, :preference_dining, :preference_gaming, :preference_other, :preference_entertainment, :preference_transportation, 
                                :preference_accomodations_level, :preference_dining_level, :preference_gaming_level, :preference_other_level, :preference_entertainment_level, :preference_transportation_level)
  end
  
  
  
end
