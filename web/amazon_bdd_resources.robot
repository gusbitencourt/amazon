*** Settings ***
Resource    amazon_resources.robot

*** Keywords ***
Given that I searched for "Iphone" on Amazon Brazil
    Search For "Iphone" Using The Search Bar On Amazon Brazil

Then I am able to see the amount of results searched
    Count The Total List Of Found Itens

And count the itens that starts with "Iphone"
    Count Items Which Its Name Starts With "Iphone"
    
And check if those are at least 30% of the total of the resutls shown
    Make Sure At Least "30"% Of Items Found Has Its Name Starting With "Iphone”

Then I am able to select the most expensive result that starts with "Iphone"
    Find The The More Expensive Item which its name starts with "Iphone”

And use the exchangerateapi.io API to convert the the value into USD
    Convert Its Value To USD Using https://exchangeratesapi.io/ API

And check if the USD value is not greater than 2000
    Make Sure The Converted Value Is Not Greater Than US "2000"
Then I am able to select the results that does not start with "Iphone"
    Find Items which its name doesn't start with "Iphone”

And check if all the values of the products are cheaper than the cheapest Item that its name start with "Iphone"
    Make Sure All Found Products Are Cheaper Than The Cheapest Item which its name starts with "Iphone"
