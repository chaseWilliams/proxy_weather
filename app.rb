require './router/loader'

class App < Sinatra::Application

  # Remember that this is a helper function that will process each request (regardless of endpoint) before
  # processing the get/post/put sections below
  before do
    content_type 'application/json'
    # [...other code will go here, if needed...]
  end

  # You'll repeat this for each endpoint this app will host and for each HTTP method
  get '/<whatever_path>' do
    # [...your code will go here...]
  end

end
