# frozen_string_literal

module Function
  # 文字パディングクラス
  class Padding
    def call(data, args)
      data = data.to_s
      target_byte_size = args[0].to_i
      fill_string = args[1].to_s
      direction = args[2].to_s

      data_bytes = data.encode('UTF-8').bytesize

      return data if data_bytes >= target_byte_size

      fill_string_bytes = fill_string.encode('UTF-8').bytesize
      fill_bytes = target_byte_size - data_bytes
      fill_count = fill_bytes / fill_string_bytes

      case direction
      when 'left'
        (fill_string * fill_count) + data
      when 'right'
        data + (fill_string * fill_count)
      else
        data
      end
    end
  end
end
