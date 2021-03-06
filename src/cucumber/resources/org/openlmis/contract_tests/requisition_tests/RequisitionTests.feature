@RequisitionTests
Feature: Requisition Tests


  Scenario: StoreInCharge user should be able to approve a requisition
    Given I have logged in as StoreInCharge

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 2                     | 3                | 1                 | 2                 | 5                     |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 2                     | 3                | 1                 | 2                 | 5                     | 5     |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to authorize a requisition
    Then I should get a requisition with "AUTHORIZED" status

    When I try update fields in requisition:
      | approvedQuantity |
      | 4                |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | approvedQuantity |
      | 4                |

    When I try to approve a requisition
    Then I should get a requisition with "APPROVED" status
    And I logout


  Scenario: StoreInCharge user should be able to reject authorized requisition
  and delete initiated requisition
    Given I have logged in as StoreInCharge

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 7                     | 3                | 3                 | 4                 | 10                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 7                     | 3                | 3                 | 4                 | 10                    | 10    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to authorize a requisition
    Then I should get a requisition with "AUTHORIZED" status

    When I try to reject authorized requisition
    Then I should get a requisition with "INITIATED" status

    When I try to delete initiated requisition
    Then I should get response of deleted requisition

    When I try to get requisition with id
    Then I should get response of not found
    And I logout


  Scenario: StoreInCharge user should be able to approve emergency requisition
    Given I have logged in as StoreInCharge

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |

    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 20                    | 5                | 21                | 22                | 25                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 20                    | 5                | 21                | 22                | 25                    | 25    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to get period with id:
      | periodId                             |
      | 516ac930-0d28-49f5-a178-64764e22b236 |
    Then I should get response with the period id

    #Now periods in demo data are set to current year.
    #Update period to current date.
    #Period must contains current date.
    When I try update period to current date
    And I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | true      |
    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | true      |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 15                    | 15               | 6                 | 7                 | 30                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 15                    | 15               | 6                 | 7                 | 30                    | 30    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to authorize a requisition
    Then I should get a requisition with "AUTHORIZED" status

    When I try update fields in requisition:
      | approvedQuantity |
      | 10               |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | approvedQuantity |
      | 10               |

    When I try to approve a requisition
    Then I should get a requisition with "APPROVED" status
    And I logout


  Scenario: StoreInCharge user should be able to reject authorized emergency requisition
  and delete initiated emergency requisition
    Given I have logged in as StoreInCharge

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |

    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 5                     | 13               | 2                 | 7                 | 18                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 5                     | 13               | 2                 | 7                 | 18                    | 18    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to get period with id:
      | periodId                             |
      | 516ac930-0d28-49f5-a178-64764e22b236 |
    Then I should get response with the period id

    When I try update period to current date
    And I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | true      |
    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | true      |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 12                    | 20               | 8                 | 9                 | 32                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 12                    | 20               | 8                 | 9                 | 32                    | 32    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to authorize a requisition
    Then I should get a requisition with "AUTHORIZED" status

    When I try to reject authorized requisition
    Then I should get a requisition with "INITIATED" status

    When I try to delete initiated requisition
    Then I should get response of deleted requisition

    When I try to get requisition with id
    Then I should get response of not found
    And I logout


  Scenario: StoreInCharge user should get failure response if date outside of period
  when he creates emergency requisition
    Given I have logged in as StoreInCharge

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |

    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 20                    | 5                | 21                | 22                | 25                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 20                    | 5                | 21                | 22                | 25                    | 25    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to get period with id:
      | periodId                             |
      | 516ac930-0d28-49f5-a178-64764e22b236 |
    Then I should get response with the period id

    When I try update period to future date
    And I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | true      |
    Then I should get response of incorrect period
    And I logout


  Scenario: StoreInCharge user should be able to approve second emergency requisition in the same period
    Given I have logged in as StoreInCharge

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |

    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 30                    | 5                | 0                 | 8                 | 35                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 30                    | 5                | 0                 | 8                 | 35                    | 35    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to get period with id:
      | periodId                             |
      | 516ac930-0d28-49f5-a178-64764e22b236 |
    Then I should get response with the period id

    When I try update period to current date
    And I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | true      |
    Then I should get response with the initiated requisition's id
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 1                     | 1                | 16                | 17                | 2                     |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 1                     | 1                | 16                | 17                | 2                     | 2     |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to authorize a requisition
    Then I should get a requisition with "AUTHORIZED" status

    When I try update fields in requisition:
      | approvedQuantity |
      | 1                |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | approvedQuantity |
      | 1                |

    When I try to approve a requisition
    Then I should get a requisition with "APPROVED" status

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | true      |
    Then I should get response with the initiated requisition's id
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 2                     | 2                | 2                 | 2                 | 4                     |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 2                     | 2                | 2                 | 2                 | 4                     | 4     |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to authorize a requisition
    Then I should get a requisition with "AUTHORIZED" status

    When I try update fields in requisition:
      | approvedQuantity |
      | 2                |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | approvedQuantity |
      | 2                |

    When I try to approve a requisition
    Then I should get a requisition with "APPROVED" status
    And I logout


  Scenario: StoreInCharge user should be able to convert requisition to order
    Given I have logged in as StoreInCharge

    When I try to initiate a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    Then I should get response with the initiated requisition's id

    When I try to get requisition with id
    Then I should get a requisition with:
      | programId                            | facilityId                           | periodId                             | emergency |
      | dce17f2e-af3e-40ad-8e00-3496adef44c3 | e6799d64-d10d-4011-b8c2-0e4d4a3f65ce | 516ac930-0d28-49f5-a178-64764e22b236 | false     |
    And I should get a requisition with "INITIATED" status

    When I try update fields in requisition:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity |
      | 9                     | 2                | 0                 | 5                 | 11                    |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | totalReceivedQuantity | beginningBalance | totalStockoutDays | requestedQuantity | totalConsumedQuantity | total |
      | 9                     | 2                | 0                 | 5                 | 11                    | 11    |

    When I try to submit a requisition
    Then I should get a requisition with "SUBMITTED" status

    When I try to authorize a requisition
    Then I should get a requisition with "AUTHORIZED" status

    When I try update fields in requisition:
      | approvedQuantity |
      | 4                |
    And I try to get requisition with id
    Then I should get a updated requisition with:
      | approvedQuantity |
      | 4                |

    When I try to approve a requisition
    Then I should get a requisition with "APPROVED" status

    When I try to convert requisition to order
    And I try to get requisition with id
    Then I should get a requisition with "RELEASED" status
    And I logout