module Scout7
  module Objects
    class ShortReport

      # {"ReportId"=>1021666, "ReportName"=>"Uruguay (U20) vs Villarreal U20", "CreatedBy"=>"George Charlton", "CreatedOn"=>"2022-08-01T09:38:41.727", "Competition"=>"COTIF Tournament 2022", "CompetitionId"=>"797529dc-b88c-4483-ace2-212dc64793dd", "HomeTeam"=>"Uruguay (U20)", "HomeTeamId"=>"a71b428d-3f46-49d9-847f-faccd3fd4144", "ReportType"=>1, "AwayTeam"=>"Spain (Villarreal U20)", "AwayTeamId"=>"28c34267-ec90-4a30-a157-a4dbd1581c4a", "Player"=>{"PlayerId"=>"7caf785b-1df4-481a-998e-441a58a62ec9", "FirstName"=>"Joaquín", "LastName"=>"Ferreira", "AKA"=>"", "ContractEndYear"=>0, "ContractEndMonth"=>0}, "Ratings"=>[{"Position"=>"Right Back (2)"}, {"MATCH DAY GRADE"=>"C"}, {"VERDICT"=>"SCOUTING"}]}

      def initialize(data)
        @data = data
      end
      
      def data
        @data
      end

      def report_id
        @data["ReportId"]
      end

      def report_name
        @data["ReportName"]
      end

      def scout
        @data["CreatedBy"]
      end

      def created_on
        @data["CreatedOn"]
      end

      def competition
        @data["Competition"]
      end

      def competition_id
        @data["CompetitionId"]
      end

      def player
        @data["Player"]
      end

      def ratings
        @data["Ratings"].to_h
      end

      def home_team_name
        @data["HomeTeam"]
      end
      
      def home_team_id
        @data["HomeTeamId"]
      end
      
      def away_team_name
        @data["AwayTeam"]
      end
      
      def away_team_id
        @data["AwayTeamId"]
      end
      
    end
  end
end
