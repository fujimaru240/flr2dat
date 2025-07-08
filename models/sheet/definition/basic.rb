# frozen_string_literal: true

require './models/excel'
require './models/sheet/common'
require './models/sheet/record/basic'

module Definition
  # 定義基底クラス
  class Basic < Common
    COL_DEL = 1
    COL_RECORDS = 3
    ROW_SEC_COUNT = 2
    COL_SEC_COUNT = 3

    def section_count
      @sheet.get_cell_value(ROW_SEC_COUNT, COL_SEC_COUNT)
    end

    def definitions
      records = []
      (1..record_count).each do |d_cnt|
        d_row = ROW_REC_START + d_cnt - 1

        (1..section_count).each do |s_cnt|
          s_cnt = COL_RECORDS + s_cnt - 1
          section = @sheet.get_cell_value(d_row, s_cnt)

          reords_sheet = get_sheet_name(section)
          rec_def = Record::Basic.new(@book, reords_sheet, @env_name)
          records.concat(rec_def.items)
        end
      end
      records
    end

    def del_flag(row)
      flag = @sheet.get_cell_value(row, COL_DEL)
      return false if flag == 'common'

      flag == 'del' || flag != @env_name
    end
  end
end
