module Unpoly
  module Rails
    class Change

      class Field
        PARAM_PREFIX = '_up_'

        def initialize(name)
          @name = name
        end

        attr_reader :name

        def header_name
          result = name.to_s
          result = result.capitalize
          result = result.gsub(/_(.)/) { "-#{$1.upcase}" }
          result = "X-Up-#{result}"
          result
        end

        def param_name
          "#{PARAM_PREFIX}#{name}"
        end

        def parse(raw)
          raise NotImplementedError
        end

        def stringify(value)
          raise NotImplementedError
        end

        class String < Field

          def parse(raw)
            raw
          end

          def stringify(value)
            value.to_s
          end

        end

        class Boolean < Field

          def parse(raw)
            raw == 'true'
          end

          def stringify(value)
            Util.safe_json_encode(value)
          end

        end

        class Time < Field

          def parse(raw)
            if raw.present?
              ::Time.at(raw.to_i)
            end
            end

          def stringify(value)
            if value
              value.to_i
            end
          end

        end

        class Hash < Field

          def parse(raw)
            if raw.present?
              result = Util.json_decode(raw)
            else
              result = {}
            end

            if result.is_a?(::Hash)
              result = ActiveSupport::HashWithIndifferentAccess.new(result)
            end

            result
          end

          def stringify(value)
            Util.safe_json_encode(value)
          end

        end

        class Array < Field

          def parse(raw)
            if raw.present?
              result = Util.json_decode(raw)
            else
              result = []
            end

            result
          end

          def stringify(value)
            Util.safe_json_encode(value)
          end

        end

      end
    end
  end
end
