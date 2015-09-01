class OffersController < ApplicationController
  
  def index
    @open_offers = []
    @closed_offers = []
    offers = current_user.casino.offers
    offers.each do |offer|
      if offer.offer_status.nil? or offer.offer_status == "Accepted" or offer.offer_status == "Responsed" or offer.offer_status == "Confirmed"
        @open_offers << offer
      else
        if offer.offer_status != "Declined by casino" 
          @closed_offers << offer
        end
      end
    end

    puts "*****************", @closed_offers.count
  end

  def history
  end

  def new
    @offer = Offer.new
  end
  
  def create
    @offer = Offer.new(offer_params) 
    if @offer.save
      flash[:notice] = "You have successfully sent an offer to #{@offer.bid.user.player.username}.  Go to Manage Offers if you would like to review the status of your offers."
      redirect_to(controller: 'bids', action: 'casino_bids')
    else
      render('new')
    end  
  end

  def show
    @offer = Offer.find(params[:id])
    if params[:type] == 'casino'
      render('show4casino')
    else
      render('show4player')
    end
    
  end

  def edit
    @offer = Offer.find(params[:id])
  end

  def accept
    offer = Offer.find(params[:id])
    offer.bid.offers.where("offer_status is null or offer_status != ?", 'Declined by casino').each do |of|
      of.offer_status = "Declined"
      of.save
    end
    offer.offer_status = "Accepted"
    offer.save
    offer.bid.status = "Accepted"
    offer.bid.save
    flash[:accept_notification] = "Congratulations! You have successfully accepted this offer.<br/>
                                  You will receive an email or phone call from #{offer.casino.casino_name} within 24 hours with your confirmation details.
"
    redirect_to(controller: 'offers', action: 'show')
  end

  def respond
    offer = Offer.find(params[:id])
    offer.offer_status = "Responsed"
    offer.save
    offer.bid.status = "Responsed"
    offer.bid.save
    redirect_to(controller: 'offers', action: 'index')
  end

  def confirm
    offer = Offer.find(params[:id])
    offer.offer_status = "Confirmed"
    offer.save
    offer.bid.status = "Confirmed"
    offer.bid.save
    redirect_to(controller: 'offers', action: 'index')
  end

  def decline
    offer = Offer.find(params[:id])
    offer.offer_status = "Declined"
    offer.save
    redirect_to(controller: 'bids', action: 'current')
  end
  
  def update
    @offer = Offer.find(params[:id])
    if @offer.update_attributes(offer_params)
      flash[:notice] = "Your offer to '#{offer.bid_name}' was updated successfully."
      redirect_to(action: 'show', id: @offer.id)
    else
      render('edit')
    end 
  end
  
  def delete
    @offer = Offer.find(params[:id])
  end
  
  def destroy
    offer = Offer.find(params[:id]).destroy
    flash[:notice] = "Your offer to to '#{offer.bid_name}' was destroyed successfully."
    redirect_to(action:'index')
  end
  
  def offer_params
    params.require(:offer).permit(:bid_id, :casino_id, :reimbursement_bid_fee, :agree_player_requests, :offer_additional_perks, :expiration_date, 
                                  :expiration_time, :offer_comment, :message_to_player,
                                  :attach_file_to_message, :attach_file_to_message_cache,
                                  :attach_file_to_offer, :attach_file_to_offer_cache)
  end

end

