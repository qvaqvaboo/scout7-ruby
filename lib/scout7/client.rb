require "http"
require "net/http"
require "scout7/objects/fixture"
require "scout7/objects/short_report"
require "scout7/objects/report"
require "scout7/objects/report_player"

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

    def report(report_id)
      Scout7::Objects::Report.new(get_signed_request("sc7client/reports/byReportId?reportId=#{report_id}"))
    end

    def reports(start_date, end_date)
      get_signed_request("sc7client/reports/byDate?startdate=#{start_date}&enddate=#{end_date}").map { |r| Scout7::Objects::ShortReport.new(r) }
    end

    def planner(start_date, end_date)
      get_signed_request("sc7client/scoutingplanner/byDate?startdate=#{start_date}&enddate=#{end_date}")
    end

    def shortlists
      get_signed_request("sc7client/shortlists?culture=en-GB")
    end

    def notes(start_date, end_date, type)
      get_signed_request("sc7client/notes?startdate=#{start_date}&enddate=#{end_date}&notetypeid=#{type}")
    end

    def fixtures(competition_ids)
      competition_ids = [competition_ids].flatten
      data = competition_ids.map { |id| get_signed_request("sc7core/tournaments/getCompetitionFixtures?competitionId=#{id}") rescue nil }
      data.compact.flatten.map { |f| Scout7::Objects::Fixture.new(f) }
    end

    def convert_competition(competition_id)
      get_signed_request("sc7core/optaS7Convert?id=#{competition_id}&direction=5&source=3")
    end

    def tournaments
      get_signed_request("sc7core/tournaments")
    end

    def tournament_teams(competition_id)
      get_signed_request("sc7core/teams/byTournament?tournamentId=#{competition_id}")
    end

    def tournament_fixtures(competition_id)
      get_signed_request("sc7core/tournaments/getCompetitionFixtures?competitionId=#{competition_id}")
    end

    def fixture_info(fixture_id)
      get_signed_request("sc7core/tournaments/getMatchData?fixtureId=#{fixture_id}")
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
      p uri
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
