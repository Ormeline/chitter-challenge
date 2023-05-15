require './app'
run Rack::URLMap.new('/' => ApplicationController, '/peeps' => PeepController, 
'/users' => UserController)