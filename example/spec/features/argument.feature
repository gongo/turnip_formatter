Feature: A feature with argument
  Scenario: This is a feature with DocString
    When the monster sings the following song
    """
    Oh here be monsters
    This is cool
    """
    Then the song should have 2 lines

  Scenario: This is a feature with DocTable
    When there are monsters:
      | gargoyle   |
      | Cockatrice |
    Then there should be 2 monsters

