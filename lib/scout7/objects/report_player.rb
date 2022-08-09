module Scout7
  module Objects
    class ReportPlayer

      def initialize(data)
        @data = data
      end

      def player_id
        @data["PlayerId"]
      end

      def contents
        elements(@data["ReportElements"])
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