# frozen_string_literal: true

# 定義基底クラス
class Base
  CONVERT_VARIALES = {
    '$empty' => '',
    '$lf' => "\n",
    '$tab' => "\t",
    '$cr' => "\r",
    '$space' => ' '
  }.freeze

  SHEET_VARIABLE = 'sheet$'

  # init
  #
  # @param [Excel] book
  # @param [String] sheet_name
  # @param [String] env_name
  def initialize(book, sheet_name, env_name)
    @book = book
    @sheet_name = sheet_name
    @env_name = env_name
    @sheet = book.read_sheet(sheet_name)
  end

  def format_variables(var)
    if CONVERT_VARIALES.key?(var)
      CONVERT_VARIALES[var]
    else
      var
    end
  end

  def get_sheet_name(value)
    return '' if value.nil?

    value.start_with?(SHEET_VARIABLE) ? value.sub(SHEET_VARIABLE, '') : value
  end

  def sheet_name?(value)
    value.to_s.start_with?(SHEET_VARIABLE)
  end
end
