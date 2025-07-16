# frozen_string_literal: true

require './models/sheet/base'

module V2
  # 共通クラス
  class Common < Base
    ROW_LINE_COUNT = 2
    COL_LINE_COUNT = 2

    ROW_HEADER_COUNT = 4
    ROW_LINE_START = 5

    ROW_ITEM_COUNT = 2
    COL_ITEM_COUNT = 3
    COL_ITEM_START = 3

    def line_count
      @sheet.get_cell_value(ROW_LINE_COUNT, COL_LINE_COUNT)
    end

    def item_count
      @sheet.get_cell_value(ROW_ITEM_COUNT, COL_ITEM_COUNT)
    end
  end
end
