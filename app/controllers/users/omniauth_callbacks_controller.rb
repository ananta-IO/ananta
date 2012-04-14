class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.find_for_facebook(env["omniauth.auth"].extra.raw_info, current_user)

    session['facebook_cookies'] = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"

    if @user.persisted? 
      sign_in @user, :event => :authentication 
    else
      session[:facebook_user_attributes] = env["omniauth.auth"].extra.raw_info
    end

    render json: @user.to_json({:only => [:id, :email, :username, :facebook_id]})
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end