class QueryController < ApplicationController
  require 'net/http'
  require 'json'

  def new
    @site = ''
  end

  def index
    @url = params[:url]
    @api = 'AIzaSyDje4DECOCTAhqoZZkICqWRiRQVLjuEGiI';
    uri = URI('https://www.googleapis.com/pagespeedonline/v3beta1/mobileReady?url=' + @url +'&strategy=mobile&key=' + @api)
    @res = Net::HTTP.get(uri)
    @obj = JSON.parse(@res)
    @responsive_score = @obj['ruleGroups']['USABILITY']

    uri = URI('https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=' + @url +'&strategy=mobile&screenshot=true&key=' + @api)
    @res = Net::HTTP.get(uri)
    @obj = JSON.parse(@res)

    # Mobile
    @viewport_score = @obj['formattedResults']['ruleResults']['ConfigureViewport']['ruleImpact']
    @mobile_screenshot = "data:" + @obj['screenshot']['mime_type'].to_s + ";base64," + @obj['screenshot']['data'].to_s.gsub(/_/,'/').gsub(/-/,'+')


    uri = URI('https://www.googleapis.com/pagespeedonline/v2/runPagespeed?url=' + @url +'&screenshot=true&key=' + @api)
    @res = Net::HTTP.get(uri)
    @obj = JSON.parse(@res)

    @speed_score = @obj['ruleGroups']['SPEED']['score']
    @page_size = calculate_page_size
    @page_requests = @obj['pageStats']['numberResources']
    @browser_caching = @obj['formattedResults']['ruleResults']['LeverageBrowserCaching']['ruleImpact']
    @redirects = @obj['formattedResults']['ruleResults']['AvoidLandingPageRedirects']['ruleImpact']
    @compression = @obj['formattedResults']['ruleResults']['EnableGzipCompression']['ruleImpact']
    @render_blocking = @obj['formattedResults']['ruleResults']['MinimizeRenderBlockingResources']['ruleImpact']
    @desktop_screenshot = "data:" + @obj['screenshot']['mime_type'].to_s + ";base64," + @obj['screenshot']['data'].to_s.gsub(/_/,'/').gsub(/-/,'+')

    @mozaccess = 'mozscape-ffb6973301'
    @secret = 'a997cc03e58b9efdfa14c778e467ac50'

    calculate_scores
  end


private
  def calculate_scores
    @performance_score = calculate_performance
    @mobile_score = calculate_mobile
  end

  def calculate_performance
    return {'total': 30, 'pageSize': @page_size, 'pageRequests': @page_requests, 'pageSpeed': @speed_score, 'browserCaching': @browser_caching, 
      'pageRedirects': @redirects, 'compression': @compression, 'renderBlocking': @render_blocking}
  end

  def calculate_mobile
    viewport_score = 10.0 - @viewport_score.to_i
    responsive_score = @responsive_score ? 20 : 10
    total_score = viewport_score + responsive_score
    return {'total': total_score.round, 'responsive': responsive_score.round, 'viewport': viewport_score.round}
  end

  def calculate_page_size
    html = @obj['pageStats']['htmlResponseBytes']
    css = @obj['pageStats']['cssResponseBytes']
    img = @obj['pageStats']['imageResponseBytes']
    js = @obj['pageStats']['javascriptResponseBytes']
    other = @obj['pageStats']['otherResponseBytes']
    total = html.to_f + css.to_f + img.to_f + js.to_f + other.to_f
    return total / 1000000
  end
end