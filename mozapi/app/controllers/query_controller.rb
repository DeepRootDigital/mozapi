class QueryController < ApplicationController
  require 'net/http'
  require 'json'
  def index
    @url = 'http://www.businessonmarketst.com'
    @api = 'AIzaSyDje4DECOCTAhqoZZkICqWRiRQVLjuEGiI';
    uri = URI('https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=' + @url +'&key=' + @api);
    @res = Net::HTTP.get(uri);
    @obj = JSON.parse(@res)


    @speed_score = @obj['ruleGroups']['SPEED']
    @landing_page = @obj['formattedResults']['ruleResults']['AvoidLandingPageRedirects']

    uri = URI.parse('http://www.businessonmarketst.com')
    @page_size = Net::HTTP.get_response(uri).body.length
    @page_size = @page_size.to_f / 1000000


    @mozaccess = 'mozscape-ffb6973301';
    @secret = 'a997cc03e58b9efdfa14c778e467ac50';
  end
end