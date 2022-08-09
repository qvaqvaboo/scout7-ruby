module Scout7
  module Objects
    class ReportPlayer

      def initialize(data)
        @data = data
      end

      def player_id
        @data["PlayerId"]
      end

      def name
        contents["Player Name"]
      end

      def contents
        @contents ||= elements(@data["ReportElements"])
      end

      private

      def elements(els)
        map = {}
        verdicts = []
        elements = els.flat_map do |e|
          if e["ReportElement"] == "ComboBoxVerdict"
            e["Fields"].each { |f| map[f["Label"]] = f["TextValue"] }
            next
          end

          e["Fields"].each do |field|
            key = field["Label"]
            value = field["Value"]
            if field.keys - ["Label", "Value"] != []
              value = field
              value.delete("Label")
              value['text'] = value.delete('TextValue') if value['TextValue']
              value['value'] = value.delete('Value') if value['Value']
            end
            map[key] = value
          end
        end

        map
      end


    end
  end
end