# frozen_string_literal: true

require './models/excel'
require './models/sheet/common'
require './models/function/padding'

module Record
  # レコード基本クラス
  class Basic < Common
    COL_COL_COUNT = 1
    ROW_COL_COUNT = 3
    COL_DATA_START = 3

    ROW_BYTE_SIZE = 3

    def col_count
      @sheet.get_cell_value(COL_COL_COUNT, ROW_COL_COUNT).to_i
    end

    def items
      items = []
      (1..record_count).each do |i_cnt|
        i_row = ROW_REC_START + i_cnt - 1

        record = []
        (1..col_count).each do |d_cnt|
          d_col = COL_DATA_START + d_cnt - 1
          data = format_variables(@sheet.get_cell_value(i_row, d_col))
          byte_size = @sheet.get_cell_value(ROW_BYTE_SIZE, d_col).to_i

          data = space_padding(data, byte_size)
          record.push(data)
        end
        items.push(record.join(''))
      end
      items
    end

    def space_padding(data, byte_size)
      Function::Padding.new.call(data, [byte_size, ' ', 'right'])
    end
  end
end
