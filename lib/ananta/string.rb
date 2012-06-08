module Ananta
  module String
    def rand_s(size = 2, min = 32, max = 126)
      (1..size).map{min.+(rand(1+max-min)).chr}.join
    end

    def next_s(s, l = s.length, i = 1, min = 32, max = 126)
      # Returns the mathematical next string based on the character codes of the input string
      if l-i < 0
        s = (0..l).map{min.chr}.join #start over increasing length of string by one char
      elsif s[l-i].ord >= max
        s[l-i] = min.chr
        i += 1
        s = next_s(s, l, i, min, max) #recur
      else
        s[l-i] = (s[l-i].ord + 1).chr #increment by 1
      end
      s
    end

    def base_convert_i_to_s(i, s = "", min = 32, max = 126)
      # Returns a base conversion <base = (1 + max - min)> in the form of an ASCII character string
      mx = 1+max-min
      if i == 0
        return s
      elsif i < mx
        s = (min-1+i).chr + s
        return s
      elsif i%mx == 0
        s = max.chr + s
        i = (i-1)/mx
        s = base_convert_i_to_s(i, s, min, max)
      else
        s = (min-1+(i%mx)).chr + s
        i = i/mx
        s = base_convert_i_to_s(i, s, min, max)
      end
      s
    end

    def base_convert_s_to_i(s, i = 0, min = 32, max = 126)
      # Returns a base conversion <base = (1 + max - min)> in the form of a decimal int
      mx = 1+max-min
      if s == ""
        return i
      else
        index = 0
        s.reverse!
        s.each_char do |char|
          i += (mx**index)*(char.ord-min+1)
          index += 1
        end
      end
      i
    end
  end
end