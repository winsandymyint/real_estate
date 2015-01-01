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
    #puts result["postings"].first["images"].first["full"]
  	#puts JSON.pretty_generate result["postings"]

  	# #Store result in database
  	result["postings"].each do |posting|
  		#Create new post
  		@post = Post.new
  		@post.heading= posting["heading"]
  		@post.body= posting["body"]
  		@post.price= posting["price"]
  		@post.price= posting["price"]
  		@post.neighborhood= Location.find_by(code: posting["location"]["locality"]).try(:name)
  		@post.external_url= posting["external_url"]
  		@post.timestamp= posting["timestamp"]
      @post.bedrooms = posting["annotations"]["bedrooms"] if posting["annotations"]["bedrooms"].present?
      @post.bathrooms = posting["annotations"]["bathrooms"] if posting["annotations"]["bathrooms"].present?
      @post.sqft = posting["annotations"]["sqft"] if posting["annotations"]["sqft"].present?
      @post.cats = posting["annotations"]["cats"] if posting["annotations"]["cats"].present?
      @post.dogs = posting["annotations"]["dogs"] if posting["annotations"]["dogs"].present?
      @post.w_d_in_unit = posting["annotations"]["w_d_in_unit"] if posting["annotations"]["w_d_in_unit"].present?
      @post.street_parking = posting["annotations"]["street_parking"] if posting["annotations"]["street_parking"].present?
  		#Save Post
  		@post.save!


      #Loop over images and save to database
      posting["images"].each do |images|
        @images= Image.new
        @images.url= images["full"]
        @images.post_id= @post.id
        @images.save!
      end
 	  end

  end

  desc "Destroy all posting data"
  task destroy_all_posts: :environment do
    Post.destroy_all
  end

  desc "Save neighborhood code in reference table"
  task scrap_neighborhoods: :environment do
    require 'open-uri'
    require 'json'

    #Set API Token URL
    auth_token= '2175a04d219673941cbda08192bf3928'
    location_url= 'http://reference.3taps.com/locations'

    #Specify request parameter
    params= {
      auth_token: auth_token,
      level: "locality", 
      city: "USA-NYM-BRL"
    }

    #Prepare API request
    uri = URI.parse(location_url)
    uri.query= URI.encode_www_form(params)

    #Sumit request
    #result= open(uri).read
    result= JSON.parse(open(uri).read)

    #Display the result to screen
    #puts result

    # #Store result in database
    result["locations"].each do |location|
      #Create new post
      @location = Location.new
      @location.code= location["code"]
      @location.name= location["short_name"]
      @location.save!
    end
  end

end
