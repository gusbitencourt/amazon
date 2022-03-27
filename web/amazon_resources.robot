*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RequestsLibrary
Library    String

*** Variables ***
#Google
${googleSearchField}    css:input[type='text']
#Amazon
${results}              //div[@data-component-type="s-search-result"]
${startsIphone}         //div[@data-component-type="s-search-result"]//h2//span[starts-with(translate(text(),'IPHONE', 'iphone'),'iphone')]
${notStartsIphone}      //div[@data-component-type="s-search-result"]//h2//span[not(starts-with(translate(text(),'IPHONE', 'iphone'),'iphone'))]
${getPrice}             /../../../..//*[@class='a-price-whole']
#Exchange Rate
${exchangeRate}         http://api.exchangeratesapi.io/v1/

*** Keywords ***
Test Start
    [Documentation]    Test Setup Keyword
    Open Browser    url=http://www.google.com                    browser=chrome
    Input Text      ${googleSearchField}                         Amazon Brasil
    Press Keys      ${googleSearchField}                         RETURN
    Click Element   //a[@href="https://www.amazon.com.br/"]

Test End
    [Documentation]    Test Teardown Keyword
    Capture Page Screenshot
    Close Browser

Verify if the footer of the page is loaded
    [Documentation]    Keyword to verify is the footer of the page is loaded
    Wait Until Page Contains Element                                //span[contains(text(), 'Pesquisas relacionadas')]
    

Search For "${searchedItem}" Using The Search Bar On Amazon Brazil
    [Documentation]    Keyword to input a text in the Amazon Brazil search bar
    Input Text         locator=twotabsearchtextbox        text=${searchedItem}
    Click Button       locator=nav-search-submit-button

Count The Total List Of Found Itens
    [Documentation]    Keyword to show the total itens searched
    Verify if the footer of the page is loaded
    ${numberOfSearched}=                Get Element Count           ${results}
    Log                                 ${numberOfSearched} Results Shown
    Set Test Variable                   ${numberOfSearched}

Count Items which Its Name Starts With "Iphone"
    [Documentation]    Keyword to count how many itens found starts with "Iphone"
    Verify if the footer of the page is loaded
    ${count}=                              Get Element Count        ${startsIphone}
    Log                                    Items found: ${count}
    Set Test Variable                      ${count}        

Make Sure At Least "30"% Of Items Found Has Its Name Starting With "Iphone”
    [Documentation]    Keyword that caculates the percentage of itens found that starts with "Iphone"
    ${result}=         Evaluate    ${count} * 100 / ${numberOfSearched}
    Log                Expected that more than 30% of the results mets criteria, the percentage that was found is ${result}
    Should Be True     ${result} > 30

Find The The More Expensive Item which its name starts with "Iphone”
    [Documentation]    Keyword that gets the more expensive priced item that starts with "Iphone"
    ${highestPrice}=                Set Variable       0
    @{webElementsStartsIphone}=     Get WebElements    ${startsIphone}${getPrice}
    FOR    ${webElement}    IN    @{webElementsStartsIphone}
           ${price}=    Get Text    ${webElement}
           ${price}=    Remove String    ${price}    .
        IF  ${price} > ${highestPrice}
            ${highestPrice}=    Set Variable    ${price}
        END
    END
    Set Test Variable    ${highestPrice}
    Log    The highest price of an item that its name starts with "Iphone" is ${highestPrice}

Convert Its Value To USD Using https://exchangeratesapi.io/ API
    [Documentation]      Keyword that converts from BRL to USD
    Create Session       exchangerates          ${exchangeRate}
    ${response}          GET On Session         exchangerates                    ${exchangeRate}convert
    ...                                         params=access_key=600da1d51b97ead00b3d796d8a2b664f&from=BRL&to=USD&amount=${highestPrice}
    ${usdValue}          Get Text               ${response.json()["result"]}
    Log To Console       ${usdValue} 
    Set Test Variable    ${usdValue}

Make Sure The Converted Value Is Not Greater Than US "${value}"
    [Documentation]    Keyword that verify is the a value is greater than a sent value in USD
    Should Be True     ${usdValue} < ${value}

Find Items which its name doesn't start with "Iphone”
    [Documentation]      Keyword that selects the itens that does not start with "Iphone"
    Verify if the footer of the page is loaded
    @{itemNames}         Create List
    @{elements}          Get WebElements                   ${notStartsIphone}
    FOR    ${item}    IN    @{elements}
        ${text}    Get Text    ${item}
        Append To List    ${itemNames}    ${text}        
    END
    Log Many    Products found that the name does not start with "Iphone":    @{itemNames}

Make Sure All Found Products Are Cheaper Than The Cheapest Item which its name starts with "Iphone"
    [Documentation]    Keyword that checks if the values of the itens that not starts with "Iphone"
    ...                is chepeast than the itens that have its name starting with "Iphone"
    Verify if the footer of the page is loaded
    @{allPrices}                    Create List
    ${lowestPrice}                  Set Variable       0
    @{webElementsStartsIphone}=     Get WebElements    ${startsIphone}${getPrice}
    FOR    ${webElement}    IN    @{webElementsStartsIphone}
        ${priceLow}=    Get Text    ${webElement}
        ${priceLow}=    Remove String    ${priceLow}    .
        IF    ${lowestPrice} == 0
            ${lowestPrice}=    Set Variable    ${priceLow}
        ELSE IF    ${priceLow} > ${lowestPrice}
            ${lowestPrice}=     Set Variable     ${priceLow}
        END
    END
    ${productPrice}=                 Set Variable       0
    @{webElementsNotStartsIphone}=     Get WebElements    ${notStartsIphone}${getPrice}
    FOR    ${webElement}    IN    @{webElementsNotStartsIphone}
           ${priceAll}=    Get Text    ${webElement}
           ${priceAll}=    Remove String    ${priceAll}    .
           Append To List    ${allPrices}    ${priceAll}
           Should Be True    ${lowestPrice} > ${priceAll}
    END
    Log    Cheapster item price starting with "Iphone": ${lowestPrice}
    Log Many    Itens that does not start with "Iphone" values: @{allPrices} 