# frozen_string_literal: true

require 'rubyXL'

# Excel操作クラス
class Excel
  CONVERT_STRING = '(string)'

  def initialize(file)
    @workbook = RubyXL::Parser.parse(file)
  end

  def read_sheet(sheet_name)
    Sheet.new(@workbook[sheet_name])
  end

  # Excelシート操作クラス
  class Sheet
    def initialize(sheet)
      @sheet = sheet
    end

    def get_cell_value(row, col)
      cell = @sheet[row - 1][col - 1]
      return '' if cell.nil?

      format_value(cell.value)
    end

    def format_value(value)
      return '' if nil_or_empty?(value)

      if value.to_s.start_with?(CONVERT_STRING)
        trim_string(value, CONVERT_STRING)
      else
        value
      end
    end

    def trim_string(value, pattern)
      value.to_s.sub(pattern, '')
    end

    def nil_or_empty?(value)
      return false if value.is_a?(FalseClass) || value.is_a?(TrueClass)
      return true if value.nil?
      return false if value.is_a?(Integer)

      true if value.empty?
    end
  end
end
