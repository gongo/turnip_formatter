Feature: Battle a monster with weapon

  Background:
    Given I equip a weapon

  Scenario: normal monster
    Given there is a monster
     When I attack it
     Then it should die
      And Fanfare

  Scenario: strong monster
    Given there is a strong monster
     When I attack it
     Then it should die
      And Fanfare
 
  Scenario: boss monster

    This scenario will error
    So, fanfare is not...oh...

    Given there is a boss monster
     When I attack it
     Then it should die
      And Fanfare
