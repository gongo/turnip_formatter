Feature: Battle a monster with weapon

  Background:
    Given I equip a weapon

  Scenario: normal monster
    Given there is a monster
     When I attack it
     Then it should die
      And Fanfare

  Scenario: strong monster

    His attacks can defeat strong monster if has weapon.

    Given there is a strong monster
     When I attack it
     Then it should die
      And Fanfare

  Scenario: [ERROR] boss monster

    This scenario will not success.
    Because his attacks can't defeat boss monster even if has weapon.

    Given there is a boss monster
     When I attack it
     Then it should die
      And Fanfare
