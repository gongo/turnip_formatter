Feature: Battle monsters

  Scenario: Escape
    Given there are monsters:
      | gargoyle   |
      | Cockatrice |
     When I escape
     Then I was able to escape

  Scenario: Inescapable
    Given there are monsters:
      | gargoyle   |
      | Cockatrice |
      | basilisk   |
     When I escape
     Then I could not escape
