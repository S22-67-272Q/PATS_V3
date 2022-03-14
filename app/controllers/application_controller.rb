class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # just show a flash message instead of full CanCan exception
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to take this action.  Go away or I shall taunt you a second time."
    redirect_to home_path
  end

  # handle 404 errors with an exception as well
  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:error] = "Seek and you shall find... but not this time"
    redirect_to home_path
  end
  

  private
  # Handling authentication

  # Being "Logged in" or "Logged out" doesn't do us any good unless the application dynamically changes based on that state.
  # Here's how to make our application show which user is logged in and give options to sign up, log in, or sign out 
  # depending on state (logged in or out).
  # Let's start by making a current_user helper that we can call from any controller or view.
  # It will let us check if there is a current_user

  # Having discussed how to store the user's id in the session rails hash for later use, 
  # we now need to learn how to retrieve the user on subsequent page views.

  # ------------ Find the current user details ---------------------
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # TIP: The ||= part ensures this helper doesn't hit the database every time a user hits a web page.
    #  It will look it up once, then cache it in the @current_user variable.
    # It it checks first if a current_user is already fetched (not nil) and fetches it from the User table only if it is nil.
    #  We go to the session hash, If in fact the user_id is in the session hash, 
    # then go ahead and define the current user by that id.
  end
  # Make the current_user method available to views also, not just controllers, by defining a helper method:
  helper_method :current_user
   # The purpose of :current_user, accessible in both controllers and views, 
  # is to allow constructions such as
    # <%= current_user.first_name %>  # Which gives us the first name of the user who is currently logged in. Note that 
    # We can do that with any field on that user's record in the user table (username, phone, etc)

    # we also need it to check the abilities of the current user, using his "role" attribute


  # ----------------------------- Check if the session is still active: the user is still logged in -----------------------------
  #  We will also need to check if the user is logged_in? 
  # This is done just by finding a current_user.

    def logged_in?
    current_user
  end
  # Make the logged_in? method available to views also, not just controllers, by defining a helper method.
  # we can use it to decide which menu/navigation bar we can show to the user
  # if the user is logged_in, she can see the menu with the operations on Owners, Pets, etc.
  # If the user is a guest (not logged in), she can only see general details and cannot see the nafigation bar decribed above.
  helper_method :logged_in?
  

  # This is a method that could be used as a callback handler
  # For example to check if the user is logged it before any action
  # check the owners_controller, or pets_controller for instance
  # and cannot be called in views, as we did not create a helper for it
  def check_login
    redirect_to login_path, alert: "You need to log in to view this page." if current_user.nil?
  end
end
