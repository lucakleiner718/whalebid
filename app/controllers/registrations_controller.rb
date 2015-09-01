class RegistrationsController < Devise::RegistrationsController
  before_action :create_params, :only => [:create]
  before_action :update_params, :only => [:update]

  def new
    resource = build_resource({})
    if params[:type] =="casino"
      resource.build_casino
    elsif
      resource.build_player
    end
    respond_with_navigational(resource)
  end

  def destroy
    resource.close_account
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  
  def create_params
    if params[:type] =="casino"
      devise_parameter_sanitizer.for(:sign_up) do |u| 
        u.permit(:email,:password, :password_confirmation, 
                 casino_attributes: [:casino_name, :casino_market, :address, :city, :state, 
                          :postal_code, :country, :phone, :website, :contact_first_name, :contact_last_name, 
                          :contact_title, :office_phone, :mobile_phone, :contact_message,
                          :total_table_games, :total_slot_machines, :have_vip_room, :have_vip_lounge,
                          :have_private_gaming_tables, :how_many_gaming_tables, :how_many_slot_machines,
                          :max_bet_blackjack, :max_bet_baccarat, :max_bet_roulette, :max_bet_craps,
                          :have_sports_betting_lounge, :betting_limit_on_single_sporting,
                          :subscription,
                          :casino_image_1, :casino_image_1_cache,
                          :casino_image_2, :casino_image_2_cache,
                          :casino_image_3, :casino_image_3_cache,
                          :feature_image_1, :feature_image_1_cache, :feature_description_1,
                          :feature_image_2, :feature_image_2_cache, :feature_description_2,
                          :feature_image_3, :feature_image_3_cache, :feature_description_3,
                          :avatar, :avatar_cache]) 
      end
    else
      devise_parameter_sanitizer.for(:sign_up) do |u| 
        u.permit(:email,:password, :password_confirmation, 
                 player_attributes: [:username, :first_name, :last_name, :gender, :avatar, :first_name, :last_name, 
                          :date_of_birth, :phone, :address, :city, :state, :postalcode, 
                          :country, :avatar, :wager_level, :avatar_cache]) 
      end
    end
  end

  def update_params
    if params[:type] == "casino"
      devise_parameter_sanitizer.for(:account_update) do |u| 
        u.permit(:email,:password, :password_confirmation, :current_password,
                 casino_attributes: [:id, :casino_name, :casino_market, :address, :city, :state, 
                          :postal_code, :country, :phone, :website, :contact_first_name, :contact_last_name, 
                          :contact_title, :office_phone, :mobile_phone, :contact_message,
                          :total_table_games, :total_slot_machines, :have_vip_room, :have_vip_lounge,
                          :have_private_gaming_tables, :how_many_gaming_tables, :how_many_slot_machines,
                          :max_bet_blackjack, :max_bet_baccarat, :max_bet_roulette, :max_bet_craps,
                          :have_sports_betting_lounge, :betting_limit_on_single_sporting,
                          :subscription,
                          :casino_image_1, :casino_image_1_cache,
                          :casino_image_2, :casino_image_2_cache,
                          :casino_image_3, :casino_image_3_cache,
                          :feature_image_1, :feature_image_1_cache, :feature_description_1,
                          :feature_image_2, :feature_image_2_cache, :feature_description_2,
                          :feature_image_3, :feature_image_3_cache, :feature_description_3,
                          :avatar, :avatar_cache]) 
      end
    else
      devise_parameter_sanitizer.for(:account_update) do |u| 
        u.permit(:email,:password, :password_confirmation, :current_password,
                 player_attributes: [:username, :first_name, :last_name, :gender, :avatar, :first_name, :last_name, 
                          :date_of_birth, :phone, :address, :city, :state, :postalcode, 
                          :country, :avatar, :wager_level, :avatar_cache, :id]) 
      end
    end
  end

  private :create_params
  private :update_params
end