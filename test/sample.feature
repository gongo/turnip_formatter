Feature: Feature

  Scenario: Scenario
    When step
    When step with DocString
      """
      DocString
      """
    When step with DataTable:
      | nam   | age |
      | Tom   |  10 |
      | Jerry |  23 |

  @tag1 @tag2
  Scenario: Scenario With Tags
    When step
