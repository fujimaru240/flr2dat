# frozen_string_literal: true

require './models/excel'
require './models/sheet/common'

module Record
  # レコード基本クラス
  class Basic < Common
    COL_RECORD = 2

    def items
      items = []
      (1..record_count).each do |i_cnt|
        i_row = ROW_REC_START + i_cnt - 1
        items.push(@sheet.get_cell_value(i_row, COL_RECORD))
      end
      items
    end
  end
end
