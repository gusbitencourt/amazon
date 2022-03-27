*** Settings ***
Resource    amazon_bdd_resources.robot
Resource    amazon_resources.robot

Test Setup       Test Start
Test Teardown    Test End

*** Test Cases ***
80% Of Shown Products Should Be Exclusively The Searched Product
    Given that I searched for "Iphone" on Amazon Brazil
    Then I am able to see the amount of results searched
    And count the itens that starts with "Iphone"
    And check if those are at least 30% of the total of the resutls shown

The Higher Price In The First Page Can't Be Greater Than U$2000
    Given that I searched for "Iphone" on Amazon Brazil
    Then I am able to select the most expensive result that starts with "Iphone"
    And use the exchangerateapi.io API to convert the the value into USD
    And check if the USD value is not greater than 2000

Products Different Than The Searched Product Should Be Cheaper Than The Searched Product
    Given that I searched for "Iphone" on Amazon Brazil
    Then I am able to select the results that does not start with "Iphone"
    And check if all the values of the products are cheaper than the cheapest Item that its name start with "Iphone"