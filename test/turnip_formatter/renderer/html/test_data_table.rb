require 'helper'
require 'turnip_formatter/renderer/html/data_table'
require 'turnip/table'

module TurnipFormatter::Renderer::Html
  class TestDataTable < Test::Unit::TestCase
    def test_render
      renderer = DataTable.new(
        table(
          [
            ['name', 'hp'],
            ['slime', '10'],
            ['daemon', '300']
          ]
        )
      )

      document = html_parse(renderer.render).at_xpath('table')

      assert_equal(3, document.xpath('./tr').size)
      assert_equal(6, document.xpath('.//td').size)
    end

    private

    def table(rows)
      Turnip::Table.new(rows)
    end
  end
end
