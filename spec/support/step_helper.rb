require 'support/example_helper'

module StepHelper
  include ExampleHelper

  def passed_step
    base_step(passed_example)
  end

  def failed_step
    base_step(failed_example).tap { |s| s.status = :failed }
  end

  def pending_step
    base_step(pending_example).tap { |s| s.status = :pending  }
  end

  private

    def base_step(example)
      TurnipFormatter::Step.new(example, step_description)
    end

    def step_description
      { name: 'StepName', keyword: 'Keyword', extra_args: ['Docstring'] }
    end
end
