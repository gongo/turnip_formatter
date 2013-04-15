require 'turnip/builder'

module Turnip
  class Builder
    class ScenarioOutline
      def to_scenarios(examples)
        rows = examples.rows.map(&:cells)
        headers = rows.shift
        rows.map do |row|
          Scenario.new(@raw).tap do |scenario|
            scenario.steps = steps.map do |step|
              new_description = substitute(step.description, headers, row)
              new_extra_args = step.extra_args.map do |ea|
                next ea unless ea.instance_of?(Turnip::Table)
                Turnip::Table.new(ea.map {|t_row| t_row.map {|t_col| substitute(t_col, headers, row) } })
              end
              Step1.new(new_description, new_extra_args, step.line, step.keyword)
            end
          end
        end
      end
    end

    class Step1 < Struct.new(:description, :extra_args, :line, :keyword, :tags)
      def split(*args)
        self.to_s.split(*args)
      end

      def to_s
        description
      end
    end

    def step(step)
      extra_args = []
      if step.doc_string
        extra_args.push step.doc_string.value
      elsif step.rows
        extra_args.push Turnip::Table.new(step.rows.map { |row| row.cells(&:value) })
      end
      @current_step_context.steps << Step1.new(step.name, extra_args, step.line, step.keyword)
    end
  end
end
