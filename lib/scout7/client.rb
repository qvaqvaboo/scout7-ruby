require "http"
require "net/http"
require "scout7/objects/fixture"

module Scout7
  class Client

    API = "https://data.scout7.com"
  
    attr_reader :username, :password, :api_key, :grant_type

    def initialize(username:, password:, grant_type: 'password', api_key: nil)
      @username = username
      @password = password
      @grant_type = grant_type
      @api_key = api_key
      @cache = {}
    end

    def notes
      get_signed_request("sc7client/notes?startdate=2021-01-05&enddate=2021-01-20")
    end

    def planner
      get_signed_request("sc7client/scoutingplanner/byDate?startdate=2021-01-01&enddate=2021-01-10")
    end

    def shortlists
      get_signed_request("sc7client/shortlists?culture=en-GB")
    end

    def shortlists
      get_signed_request("sc7client/shortlists?culture=en-GB")
    end

    def fixtures(competition_ids)
      competition_ids = [competition_ids].flatten
      data = competition_ids.map { |id| get_signed_request("sc7core/tournaments/getCompetitionFixtures?competitionId=#{id}") }
      data.flatten.map { |f| Scout7::Objects::Fixture.new(f) }
    end

    def competitions
      get_signed_request("sc7core/tournaments")
    end

    private

    def authorized_request
      post_urlencoded_request
    end

    def auth_header
      @auth_header ||= JSON.parse(post_urlencoded_request("token", { grant_type: grant_type, username: username, password: password }).body)['access_token']
    end

    def get_signed_request(link, params = {})
      return @cache[link] if @cache[link]
      uri = URI("#{API}/#{link}")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{auth_header}"
      req['ApiKey'] = api_key
      
      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) {|http|
        http.request(req)
      }
      
      p res

      @cache[link] = JSON.parse(res.body)
    end

    def post_urlencoded_request(uri, args = {})
      HTTP.post("#{API}/#{uri}", form: args)
    end

  end
end