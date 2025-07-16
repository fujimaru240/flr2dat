# frozen_string_literal: true

require './models/excel'
require './models/sheet/v2/common'
require './models/sheet/v2/generator/file_generator'

module V2
  module Generator
    # 生成クラス
    class Basic
      def initialize(output_dir)
        @output_dir = output_dir
      end

      def generate(definitions)
        definitions.each do |definition|
          definition.each do |def_item|
            def_item[:outpt_dir] = @output_dir unless @output_dir.empty?
            generate_pattern(def_item)
          end
        end
      rescue StandardError => e
        p e.message
        p e.backtrace
      end

      def generate_pattern(definition)
        case definition[:type]
        when 'file'
          FileGenerator.new.generate_file(definition[:template], definition[:value])
        else
          p "Unknown type: #{definition[:type]}"
        end
      end
    end
  end
end
