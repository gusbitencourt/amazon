*** Settings ***
Resource    amazon_resources.robot

Test Setup        Test Start
Test Teardown     Test End

*** Test Cases ***
80% Of Shown Products Should Be Exclusively The Searched Product
	Search For "Iphone" Using The Search Bar On Amazon Brazil
	Count The Total List Of Found Itens
    Count Items Which Its Name Starts With "Iphone"
	Make Sure At Least "30"% Of Items Found Has Its Name Starting With "Iphone”

The Higher Price In The First Page Can't Be Greater Than U$2000
	Search For "Iphone" Using The Search Bar On Amazon Brazil
	Find The The More Expensive Item which its name starts with "Iphone”
	Convert Its Value To USD Using https://exchangeratesapi.io/ API
	Make Sure The Converted Value Is Not Greater Than US "2000"

Products Different Than The Searched Product Should Be Cheaper Than The Searched Product
	Search For "Iphone" Using The Search Bar On Amazon Brazil
	Find Items Which Its Name Doesn't Start With "Iphone”
	Make Sure All Found Products Are Cheaper Than The Cheapest Item which its name starts with "Iphone"