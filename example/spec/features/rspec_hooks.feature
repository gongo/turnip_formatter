Feature: Battle a monster with hooks

  @before_hook_error
  Scenario: [ERROR] Error in before hook
    Given there is a monster
     When I attack it
     Then it should die
      And Fanfare

  @after_hook_error
  Scenario: [ERROR] Error in after hook
    Given there is a monster
     When I attack it
     Then it should die
      And Fanfare
