# frozen_string_literal: true

require 'json'
require 'nkf'

require './models/excel'
require './models/sheet/definition/basic'

# 定義生成クラス
class DefinitionGenerator
  def initialize(args)
    @args = args
  end

  def execute
    p '処理開始'

    raise 'error: 入力ファイルパスを指定して下さい' if @args.empty?

    input_file = @args[0]
    output_dir = @args[1] || './'

    generate_dat(input_file, output_dir)
    generate_ebcdic_dat(input_file, output_dir)
  rescue StandardError => e
    p e.message
    p e.backtrace
  ensure
    p '処理終了'
  end

  def generate_dat(input_file, output_dir)
    defs = get_definitions(input_file)
    file_name = get_name(input_file)
    File.open("#{output_dir}/#{file_name}_jis8.dat", 'w:iso-2022-jp') do |file|
      defs.each do |record|
        # JIS8にエンコード
        content = record.encode('ISO-2022-JP')
        file.puts content
      end
    end
  end

  def generate_ebcdic_dat(input_file, output_dir)
    defs = get_definitions(input_file)
    file_name = get_name(input_file)
    tmp_file = "#{output_dir}/#{file_name}_tmp.dat"
    output_file = "#{output_dir}/#{file_name}_ebcdic.dat"

    File.open(tmp_file, 'w') do |file|
      defs.each do |record|
        file.puts record
      end
    end

    # iconvでEBCDIC(IBM037)に変換
    system("iconv -f UTF-8 -t IBM037 #{tmp_file} > #{output_file}")

    # 一時ファイル削除
    File.delete(tmp_file) if File.exist?(tmp_file)
  end

  def get_name(input_file)
    File.basename(input_file, File.extname(input_file))
  end

  def get_definitions(input_file)
    workbook = Excel.new(input_file)
    def_obj = Definition::Basic.new(workbook, 'def', '')
    def_obj.definitions
  rescue StandardError => e
    p "error: #{e.message}"
    p e.backtrace
    {}
  end
end
