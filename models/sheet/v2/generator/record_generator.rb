# frozen_string_literal: true

require './models/excel'
require './models/sheet/v2/common'
require './models/function/padding'

module V2
  module Generator
    # レコード生成クラス
    class RecordGenerator
      def generate_record(template, value)
        record = []
        template.each do |item|
          after_value = convert_value(item[:value], value)
          record << if item[:align] == 'left'
                      padding(after_value, item[:byte_size], '0', 'left')
                    else
                      padding(after_value, item[:byte_size])
                    end
        end
        record.join
      end

      def convert_value(value, real_values)
        real_values.each do |real_value|
          return real_value[:value].to_s if real_value[:key] == value.to_s
        end
        value.to_s
      end

      def padding(data, byte_size, fill_string = ' ', direction = 'right')
        Function::Padding.new.call(data, [byte_size, fill_string, direction])
      end
    end
  end
end
