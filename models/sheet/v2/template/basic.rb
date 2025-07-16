# frozen_string_literal: true

require './models/excel'
require './models/sheet/v2/common'

module V2
  module Template
    # 定義基底クラス
    class Basic < V2::Common
      ROW_FMT_TYPE = 2
      COL_FMT_TYPE = 1

      def format_type
        @sheet.get_cell_value(ROW_FMT_TYPE, COL_FMT_TYPE)
      end

      def templates
        templates = []
        (1..line_count).each do |l_cnt|
          line = ROW_LINE_START + l_cnt - 1

          template = {}
          (1..item_count).each do |i_cnt|
            col = COL_ITEM_START + i_cnt - 1
            header = @sheet.get_cell_value(ROW_HEADER_COUNT, col)
            template[header.to_sym] = @sheet.get_cell_value(line, col)
          end
          templates << template
        end

        templates.length == 1 ? templates.first : templates
      end
    end
  end
end
