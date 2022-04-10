class SearchController < ApplicationController
  def basic_search
    redirect_back(fallback_location: home_path) if params[:query].blank?
    @query = params[:query]
    @animals= Animal.search(@query)
    @total_hits =@animals.size
    if logged_in? && current_user.role?(:vet)
      @pets = Pet.search(@query)    
      @owners = Owner.search(@query)    
      @total_hits =@animals.size+@pets.size + @owners.size
    end
  end
end
