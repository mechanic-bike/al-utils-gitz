# encoding: utf-8
module Al
  module Utils
    module Rut

      module_function

      RUT_EXPRESSION = /\A0*(\d{1,3}(\.?\d{3})*)\-?([\dkK])\z/i
      UNFORMATTED_RUT_EXPRESSION = /\A0*\d{7,8}[\dkK]\z/i
      SIMPLE_FORMATTED_RUT_EXPRESSION = /\A0*(\d{1,3}(\.?\d{3})*)\-([\dkK])\z/i

      def formatted_rut(rut)
        return '' if rut.blank?

        rut = unformatted_rut(rut)
        formatted_rut = rut[0...-1].to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
        formatted_rut << '-'
        formatted_rut << rut[-1]
      end

      def self.simple_formatted_rut(rut)
        return '' if rut.blank?

        rut = unformatted_rut(rut)
        formatted_rut = rut[0...-1]
        formatted_rut << '-'
        formatted_rut << rut[-1]
      end

      def unformatted_rut(rut)
        return '' if rut.blank?

        rut.upcase.gsub(/[^0-9Kk]/i, '').gsub(/^[0:]*/, '')
      end

      def dv_of(rut)
        rut = unformatted_rut(rut)
        dv(rut)
      end

      def dv_valid?(rut)
        rut = unformatted_rut(rut)
        rut[-1].upcase == dv(rut[0...-1])
      end

      def dv_invalid?(rut)
        !dv_valid?(rut)
      end

      def dv(crut)
        return '' if crut.blank?

        sum = rut_sum(crut)
        mod = sum % 11

        get_dv(mod)
      end

      def rut_sum(crut)
        multipliers = [2, 3, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7]
        total = 0

        crut.to_s.reverse.each_char.each_with_index do |num, index|
          total += num.to_i * multipliers[index]
        end

        total
      end

      def get_dv(mod)
        result = 11 - mod
        case result
        when 10
          'K'
        when 11
          '0'
        else
          result.to_s
        end
      end

    end
  end
end