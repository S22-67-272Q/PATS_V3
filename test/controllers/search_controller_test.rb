require "test_helper"

describe SearchController do
  it "should get basic_search" do
    get search_basic_search_url
    value(response).must_be :success?
  end

end
