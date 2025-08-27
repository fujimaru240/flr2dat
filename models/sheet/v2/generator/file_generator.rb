# frozen_string_literal: true

require './models/excel'
require './models/sheet/v2/common'
require './models/sheet/v2/generator/record_generator'
require './models/sheet/v2/generator/ebcdic_converter'

module V2
  module Generator
    # ファイル生成クラス
    class FileGenerator
      def generate_file(template, value)
        records = structure_records(value)
        output_file(template, records) unless records.empty?
      rescue StandardError => e
        p e.message
        p e.backtrace
      end

      def structure_records(value)
        records = []
        value.each do |items|
          items.each do |item|
            item[:value].each do |value_item|
              case item[:type]
              when 'record'
                records << RecordGenerator.new.generate_record(item[:template], value_item)
              else
                p "Unknown type: #{item[:type]}"
              end
            end
          end
        end
        records
      end

      def output_file(template, records)
        case template[:encoding]
        when 'JIS8'
          output_jis8_file(template[:output_dir], template[:filename], records)
        when 'EBCDIC'
          output_ebcdic_file(template[:output_dir], template[:filename], records)
        else
          p "Unsupported encoding: #{template[:encoding]}"
        end
      rescue StandardError => e
        p e.message
        p e.backtrace
      end

      def output_jis8_file(output_dir, file_name, records)
        File.open("#{output_dir}/#{file_name}", 'w:iso-2022-jp') do |file|
          records.each do |record|
            file.puts record.encode('ISO-2022-JP')
          end
        end
      end

      # 新しいoutput_ebcdic_fileメソッド
      def output_ebcdic_file(output_dir, file_name, records)
        output_file = "#{output_dir}/#{file_name}"

        File.open(output_file, 'wb') do |file|
          records.each do |record|
            begin
              # UTF-8からASCIIに正規化
              ascii_record = record.encode('ASCII', 'UTF-8', 
                                        :invalid => :replace, 
                                        :undef => :replace, 
                                        :replace => '?')
              
              # ASCIIからEBCDIC(IBM037)に変換
              ebcdic_data = EbcdicConverter.ascii_to_ebcdic(ascii_record)
              
              file.write(ebcdic_data)
              file.write(EbcdicConverter.ebcdic_newline)
              
            rescue => e
              puts "EBCDIC変換エラー: #{e.message}"
              puts "問題レコード: #{record[0..50]}..."
            end
          end
        end
        
        puts "EBCDICファイル出力完了: #{output_file}"
      end
    end
  end
end
