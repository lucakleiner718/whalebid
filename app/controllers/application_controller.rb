class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :change_bid_status
  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email,:password, :password_confirmation, player: [:first_name, :last_name, :date_of_birth, :phone, :address, :city, :state, :postalcode, :country, :username, :avatar]) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:username, :password, :remember_me) }
    # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :avatar, :first_name, :last_name, :phone, :date_of_birth, :address, :city, :state, :postalcode, :country, :gender, :password, :password_confirmation, :current_password, :wager_level) }
  end

  def after_sign_in_path_for(resource)
    @bid = Bid.first :conditions => ["user_id = ? and status = ?", current_user.id, "Active"]
    if (resource.player)
      if @bid.nil?
        flash[:notice] = ""
        history_bids_path
      else
        flash[:notice] = ""
        current_bids_path
      end
    else
      flash[:notice] = ""
      casinos_path
    end
  end

  def get_markets
    @casino_markets = ['Las Vegas Strip, Nev.',
                     'Atlantic City, N.J.',
                     'Chicagoland, Ind./Ill.',
                     'Detroit, Mich.',
                     'Connecticut',
                     'Philadelphia, Pa.',
                     'St. Louis, Mo./Ill.',
                     'Gulf Coast, Miss.',
                     'Gulf Coast, Miss.',
                     'The Poconos, Pa.',
                     'Tunica/Lula, Miss.',
                     'Kansas City, Mo.',
                     'Boulder Strip, Nev.',
                     'Shreveport/Bossier City, La.',
                     'Lake Charles, La.',
                     'New York City, N.Y.',
                     'Reno/Sparks, Nev.',
                     'Pittsburgh/Meadow Lands, Pa.',
                     'Black Hawk, Colo.',
                     'Lawrenceburg/Rising Sun/Belterra, Ind.',
                     'New Orleans, La.']
    @markets_with_count = Casino.includes(:user).where("users.status=?", "active").group("casino_market").order("casino_market").count('id')

    @total_count = Casino.includes(:user).where("users.status=?", "active").count('id')
  end

  def change_bid_status
    open_bids = Bid.all :conditions => ["close_at < ? and status = ?", Date.today.to_s, "Active"]
    open_bids.each do |bid|
      bid.status = "Closed"
      bid.save

    end
  end

end
