namespace :scraper do
  desc "Fetch Craigslist Post From 3taps"
  task scrape: :environment do
  	require 'open-uri'
  	require 'json'

  	#Set API Token URL
  	auth_token= '2175a04d219673941cbda08192bf3928'
  	polling_url= 'http://polling.3taps.com/poll'

  	#Specify request parameter
  	params= {
  		auth_token: auth_token,
  		anchor: '1656718441',
  		source: 'CRAIG',
  		category_group: 'RRRR',
  		category: 'RHFR',
  		'location.city'=> 'USA-NYM-BRL',
  		retvals: 'location,external_url,heading,body,timestamp,price,images,annotations'
  	}

  	#Prepare API request
  	uri = URI.parse(polling_url)
  	uri.query= URI.encode_www_form(params)

  	#Sumit request
  	#result= open(uri).read
  	result= JSON.parse(open(uri).read)

  	#Display the result to screen
  	#puts result
  	#puts result["postings"].first["heading"]["locality"]

  	#Store result in database
  	result["postings"].each do |posting|
  		#Create new post
  		@post = Post.new
  		@post.heading= posting["heading"]
  		@post.body= posting["body"]
  		@post.price= posting["price"]
  		@post.price= posting["price"]
  		@post.neighborhood= posting["location"]["locality"]
  		@post.external_url= posting["external_url"]
  		@post.timestamp= posting["timestamp"]

  		#Save Post
  		@post.save!

 	  end

  end

  desc "TODO"
  task destroy_all_posts: :environment do
  end

end
