module Scout7
  module Objects
    class Fixture

      # {"FixtureId"=>"9c6b0c98-81dc-4289-95a4-0b9634f6feaa", "FixtureDate"=>"2020-05-03T00:00:00", "FixtureKO"=>"12:00:00", "CompetitionName"=>"League One", "CompetitionType"=>"Domestic league", "Round"=>"Regular Season", "HomeTeamId"=>"aef1ebe0-2430-47b2-81b9-04ea14e3e60f", "HomeTeamName"=>"Lincoln City", "HomeTeamScore"=>0, "AwayTeamId"=>"b2345095-fa50-4598-a383-48a5f877ac56", "AwayTeamName"=>"Rochdale", "AwayTeamScore"=>0, "MatchPlayed"=>"0"}

      def initialize(data)
        @data = data
      end

      def id
        @data["FixtureId"]
      end

      def score
        "#{@data["HomeTeamScore"]}:#{@data["AwayTeamScore"]}"
      end

      def name
        "#{short_date}: #{@data['HomeTeamName']} v #{@data['AwayTeamName']}"
      end

      def competition_name
        @data["CompetitionName"]
      end

      def future?
        date >= Date.today
      end

      def team_plays?(team_name)
        team_names.include?(team_name)
      end

      def team_names
        [@data["HomeTeamName"], @data["AwayTeamName"]]
      end

      def human_date
        date.strftime("%b %e").gsub('  ', ' ')
      end

      def short_date
        date.strftime("%y%m%d")
      end

      def date
        Date.parse(@data["FixtureDate"])
      end

    end
  end
end