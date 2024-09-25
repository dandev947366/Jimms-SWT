# Assignment 5
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
${PRODUCT_LINK_SELECTOR}    css:.js-gtm-product-link

*** Test Cases ***
Verify Add To Cart Button for Selected Products
    [Documentation]    This test case verifies that selected products contain an "Add to Cart" button.

    Create Session    jimms    ${BASE_URL}
    Open Browser    ${BASE_URL}    ${BROWSER}

    FOR    ${category}    IN    @{CATEGORIES}
        ${category_url}    Set Variable    ${BASE_URL}${category}

        # Navigate to the category page
        Go To    ${category_url}

        # Sleep to avoid looping too fast
        Sleep    ${SLEEP_TIME}

        # Wait for the product list to load
        Wait Until Element Is Visible    css:.product-list--items

        # Get all product links on the page
        ${product_links}=    Get WebElements    ${PRODUCT_LINK_SELECTOR}

        # Click on the first two product links
        FOR    ${index}    IN RANGE    2
            ${product_link}    Set Variable    ${product_links}[${index}]
            Click Element    ${product_link}    # Click the product link to go to the product detail page
            Sleep    ${SLEEP_TIME}    # Allow the page to load

            # Check for the "Add to Cart" button by text (with normalize-space)
            Element Should Be Visible    xpath=//*[contains(normalize-space(.), 'Lisää koriin')]    msg=Add to cart button not found by text for product index ${index} in category ${category}.


            # Navigate back to the category page
            Go Back
            Sleep    ${SLEEP_TIME}    # Allow the category page to load again
        END
    END

    Close Browser
