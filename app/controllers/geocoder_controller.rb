class GeocoderController < ApiController
  before_action :authenticate_user!

  def getLocation   
    # puts request.location 
    if geocoder_params[:lat] && geocoder_params[:long] && res_loc = (Geocoder.search([geocoder_params[:lat].round(6), geocoder_params[:long].round(6)])[0].data).to_hash['address']
      render json: jsonFormat(geocoder_params[:lat].round(6), geocoder_params[:long].round(6), res_loc['city'], res_loc['country'])
    else
      if ip = request.remote_ip
        getbyIP(ip)
      else
        render json: {"permission" => false}
      end
    end
  end
  
  private
  
  def getbyIP(ip)
      res_ip = (Geocoder.search(ip)[0].data).to_hash
      loc = res_ip['loc'].split(',') unless res_ip['loc'].nil?
      
      render json: jsonFormat(loc[0].to_f.round(6), loc[1].to_f.round(6), res_ip['city'], res_ip['country'])    
  end
  
  def jsonFormat(lat, long, city, country)
    {"consumption" => geocoder_params[:consump], "ip" => geocoder_params[:ip], "latitude" => lat, "longitude" => long, "city" => city, "country" => country, "permission" => true, "address" => geocoder_params[:address]}
  end 

  def geocoder_params
    params.require(:geocoder).permit(:id, :src, :address, :consump, :ip, :lat, :long)
  end
end
