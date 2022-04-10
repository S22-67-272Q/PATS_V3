class SearchController < ApplicationController
  def basic_search
    redirect_back(fallback_location: home_path) if params[:query].blank?

    # this is the query
    @query = params[:query]

    # everyone can search for an animal name, including guests
    @animals= Animal.search(@query)
    # counting the results obtained
    @total_hits =@animals.size

    # If the user is an vet (admin), she/he can search for pets and owners, in addition to the animals
    if logged_in? && current_user.role?(:vet)
      @pets = Pet.search(@query)    
      @owners = Owner.search(@query)    
      @total_hits =@animals.size+ @pets.size + @owners.size
    end
  end
end
