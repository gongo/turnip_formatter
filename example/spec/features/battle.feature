Feature: Battle a monster

  Scenario: normal monster
    Given there is a monster
     When I attack it
     Then it should die
      And Fanfare

  Scenario: strong monster

    This scenario will error
    So, fanfare is not...oh...

    Given there is a strong monster
     When I attack it
     Then it should die
      And Fanfare

  Scenario: spell magic

    This scenario will error because he can't cast spell

    Given there is a strong monster
     When I cast a spell 'fireball'
      And I attack it
     Then it should die
      And Fanfare

  @magician
  Scenario: spell magic 

    Given there is a strong monster
     When I cast a spell 'fireball'
      And I attack it
     Then it should die
      And Fanfare
