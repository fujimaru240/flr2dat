# frozen_string_literal: true

require './models/excel'
require './models/sheet/v2/common'
require './models/sheet/v2/generator/record_generator'

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

      def output_ebcdic_file(output_dir, file_name, records)
        tmp_file = "#{output_dir}/tmp_#{file_name}"
        output_file = "#{output_dir}/#{file_name}"

        File.open(tmp_file, 'w') do |file|
          records.each do |record|
            file.puts record
          end
        end

        # iconvでEBCDIC(IBM037)に変換
        system("iconv -f UTF-8 -t IBM037 #{tmp_file} > #{output_file}")

        # 一時ファイル削除
        File.delete(tmp_file) if File.exist?(tmp_file)
      end
    end
  end
end
