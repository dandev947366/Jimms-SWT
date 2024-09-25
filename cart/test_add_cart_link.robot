# Assignment 4
# Class: Software Testing
# Professor: Esa Huiskonen
# Student: Dan Le
# Team : 4
*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary
Library    BuiltIn

*** Variables ***
${BASE_URL}    https://www.jimms.fi/fi/Product/
@{CATEGORIES}    Tietokoneet    Komponentit    Oheislaitteet    SimRacing    Verkkotuotteet    Tarvikkeet    Erikoistuotteet    Ohjelmistot
${BROWSER}    Chrome
${SLEEP_TIME}    2s  

#!SECTION - add loop through each product

*** Test Cases ***
Verify All Product Categories Have Landing Pages And Add To Cart Button
    [Documentation]    This test case verifies that all product categories return a valid landing page and contain the addto-cart-wrapper.
    Create Session    jimms    ${BASE_URL}
    Open Browser    ${BASE_URL}    ${BROWSER}
    
    FOR    ${category}    IN    @{CATEGORIES}
        ${category_url}    Set Variable    ${BASE_URL}${category}
        
        # Navigate to the category page
        Go To    ${category_url}
        
        # Sleep to avoid looping too fast
        Sleep    ${SLEEP_TIME}
        
        # Check for addto-cart-wrapper button presence
        Element Should Be Visible    xpath=//*[@id="jim-main"]/div[2]/div/div[2]/div[4]/div/div[1]/product-box/div[2]/div[3]/addto-cart-wrapper/div/a    msg=Add to cart button not found for ${category}.
    END
    
    Close Browser
