class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook(env["omniauth.auth"].extra.raw_info, current_user)

    @user.save unless @user.persisted?

    # Add facebook_cookies to the session
    session['facebook_cookies'] = Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
    sign_in @user, :event => :authentication

    render json: {user: @user.to_json, success: true}
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

end