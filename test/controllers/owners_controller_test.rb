require 'test_helper'

class OwnersControllerTest < ActionDispatch::IntegrationTest

  setup do
    login_vet #we will need to login first, in order to be able to create an owner
    @owner = FactoryBot.create(:owner) # For this controller test in here, we will need to create an owner object to test the show, update and destroy 
    # actions. We are using here a default owner as defined in the Owner factory.
  end

  test "should get index" do
    # using the GET http verb and a url that is generated automatically getting using the owners_path helper. 
    get owners_path
    assert_response :success # assert_response, a method by minitest
                             # :success, a symbol that maps back to the 200 http response code
    # If the test in line 10 passes, it means that: 
    #   1- We have a route sepcified. This route is linking the get http request verb and the URL specified to a combination of controller and action 
    #   2- We have a controller and its index action defined
    #   3- the template associated with the action is also created
      assert_not_nil assigns(:active_owners) # this tests that I have an instance variable called active_owners created in the index method
      assert_template :index
    end


  test "should get new" do
    get new_owner_path
    assert_response :success
  end

  test "should create owner" do
    assert_difference('Owner.count') do
      # post owners_path, params: { owner: { active: @owner.active, city: @owner.city, email: "eheimann@example.com", first_name: "Eric", last_name: @owner.last_name, phone: @owner.phone, state: @owner.state, street: @owner.street, zip: @owner.zip } }
      post owners_path, params: { owner: { username: "eric", password: "secret", password_confirmation: "secret", active: @owner.active, city: @owner.city, email: "eheimann@example.com", first_name: "Eric", last_name: @owner.last_name, phone: @owner.phone, state: @owner.state, street: @owner.street, zip: @owner.zip } }
    end

    assert_redirected_to owner_path(Owner.last)
  end
  

  # Now to test the create action, things get a little bit trickier. 
  # we should create an invalid owner
  test "should not create if owner or user invalid" do
    # invalid user
    post owners_path, params: { owner: { username: nil, password: "secret", password_confirmation: "secret", active: @owner.active, city: @owner.city, email: "eheimann@example.com", first_name: "Eric", last_name: @owner.last_name, phone: @owner.phone, state: @owner.state, street: @owner.street, zip: @owner.zip } }
    assert_template :new
    # invalid owner
    post owners_path, params: { owner: { username: "eric", password: "secret", password_confirmation: "secret", active: @owner.active, city: @owner.city, email: "eheimann@example.com", first_name: "Eric", last_name: @owner.last_name, phone: @owner.phone, state: "of confusion", street: @owner.street, zip: nil } }
    assert_template :new
  end

  
  test "should show owner" do
    get owner_path(@owner)
    assert_response :success
    assert_not_nil assigns(:current_pets) # this tests that I have an instance variable called current_pets created in the show method
  end

  test "should get edit" do
    get edit_owner_path(@owner)
    assert_response :success
  end

  test "should update owner" do
    patch owner_path(@owner), params: { owner: { active: @owner.active, city: @owner.city, email: @owner.email, first_name: "Alexander", last_name: @owner.last_name, phone: @owner.phone, state: @owner.state, street: @owner.street, zip: @owner.zip } }
    assert_redirected_to owner_path(@owner)

    patch owner_path(@owner), params: { owner: { active: @owner.active, city: @owner.city, email: @owner.email, first_name: nil, last_name: @owner.last_name, phone: @owner.phone, state: @owner.state, street: @owner.street, zip: @owner.zip } }
    assert_template :edit
  end

  test "should not destroy owner" do
    assert @owner.active
    ## We no longer allow owners to be destroyed
    assert_difference('Owner.count', 0) do
      delete owner_path(@owner)
    end
    assert_not_nil assigns(:current_pets) # this tests that I have an instance variable called current_pets created in the show method

    ## ... but they are now made inactive
    @owner.reload
    deny @owner.active
  end
end
