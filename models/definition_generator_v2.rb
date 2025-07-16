# frozen_string_literal: true

require 'json'
require 'nkf'

require './models/excel'
require './models/sheet/v2/definition/basic'
require './models/sheet/v2/generator/basic'

# 定義生成クラス
class DefinitionGeneratorV2
  def initialize(args)
    @args = args
  end

  def execute
    p '処理開始'

    raise 'error: 入力ファイルパスを指定して下さい' if @args.empty?

    input_file = @args[0]
    output_dir = @args[1] || './'

    defs = get_definitions(input_file)
    V2::Generator::Basic.new(output_dir).generate(defs)
  rescue StandardError => e
    p e.message
    p e.backtrace
  ensure
    p '処理終了'
  end

  def get_definitions(input_file)
    workbook = Excel.new(input_file)
    def_obj = V2::Definition::Basic.new(workbook, 'root', '')
    def_obj.definitions
  rescue StandardError => e
    p "error: #{e.message}"
    p e.backtrace
    {}
  end
end
