module TurnipFormatter
  module Resource
    module Step
      module FailureResult
        def failed?
          !exceptions.empty?
        end

        def exceptions
          @exceptions ||= []
        end

        #
        # @param  [Array<Exception>]  exs
        #
        def set_exceptions(exs)
          if !exs.is_a?(Array)
            exs = [exs]
          end

          exceptions.concat(exs)
        end
      end
    end
  end
end
