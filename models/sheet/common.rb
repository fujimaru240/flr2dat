# frozen_string_literal: true

require './models/sheet/base'

# 共通クラス
class Common < Base
  ROW_REC_COUNT = 1
  COL_REC_COUNT = 2
  ROW_REC_START = 5

  def record_count
    @sheet.get_cell_value(ROW_REC_COUNT, COL_REC_COUNT)
  end
end
