# frozen_string_literal: true

require './models/excel'
require './models/sheet/v2/common'
require './models/sheet/v2/template/basic'

module V2
  module Definition
    # 定義基底クラス
    class Basic < V2::Common
      def definitions
        definitions = []
        (1..line_count).each do |l_cnt|
          line = ROW_LINE_START + l_cnt - 1

          definition = []
          (1..item_count).each do |i_cnt|
            col = COL_ITEM_START + i_cnt - 1
            header = @sheet.get_cell_value(ROW_HEADER_COUNT, col)
            item = @sheet.get_cell_value(line, col)

            item_hash = {}
            if sheet_name?(item)
              item_def =
                V2::Definition::Basic.new(@book, get_sheet_name(item), @env_name)

              template = V2::Template::Basic.new(@book, get_sheet_name(header), @env_name)

              item_hash[:type] = template.format_type
              item_hash[:template] = template.templates
              item_hash[:value] = item_def.definitions
            else
              item_hash[:key] = header
              item_hash[:value] = item
            end
            definition << item_hash
          end
          definitions.push(definition.length == 1 ? definition.first : definition)
        end
        # definitions.length == 1 ? definitions.first : definitions
        definitions
      end

      def del_flag(row)
        flag = @sheet.get_cell_value(row, COL_DEL)
        return false if flag == 'common'

        flag == 'del' || flag != @env_name
      end
    end
  end
end
