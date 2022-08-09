module Scout7
  module Objects
    class Report

      # {"ReportId"=>1021666, "ReportName"=>"Uruguay (U20) vs Villarreal U20", "CreatedBy"=>"George Charlton", "CreatedOn"=>"2022-08-01T09:38:41.727", "Competition"=>"COTIF Tournament 2022", "CompetitionId"=>"797529dc-b88c-4483-ace2-212dc64793dd", "HomeTeam"=>"Uruguay (U20)", "HomeTeamId"=>"a71b428d-3f46-49d9-847f-faccd3fd4144", "ReportType"=>1, "AwayTeam"=>"Spain (Villarreal U20)", "AwayTeamId"=>"28c34267-ec90-4a30-a157-a4dbd1581c4a", "Player"=>{"PlayerId"=>"7caf785b-1df4-481a-998e-441a58a62ec9", "FirstName"=>"Joaquín", "LastName"=>"Ferreira", "AKA"=>"", "ContractEndYear"=>0, "ContractEndMonth"=>0}, "Ratings"=>[{"Position"=>"Right Back (2)"}, {"MATCH DAY GRADE"=>"C"}, {"VERDICT"=>"SCOUTING"}]}

      def initialize(data)
        @data = data
      end

      def type
        @data["ReportType"]
      end

      def template
        @data["TemplateName"]
      end

      def match_name
        @data["Name"]
      end

      def metadata
        @metadata ||= elements(@data["ReportElements"])
      end

      def scout
        metadata.dig('Author')
      end

      def players
        (@data["PlayerElements"] || []).map do |player|
          Scout7::Objects::ReportPlayer.new(player)
        end
      end

      private

      def elements(els)
        els.flat_map { |e| e["Fields"] }.map do |field|
          key = field["Label"]
          value = field["Value"]
          if field.keys - ["Label", "Value"] != []
            value = field
            value.delete("Label")
            value['text'] = value.delete('TextValue') if value['TextValue']
            value['value'] = value.delete('Value') if value['Value']
          end
          key && [key, value]
        end.compact.to_h
      end

    end
  end
end