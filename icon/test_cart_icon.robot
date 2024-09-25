# Assignment 4
# Class: Software Testing
# Professor: Esa Huiskonen
# Student: Dan Le
# Team : 4
*** Settings ***
Library    SeleniumLibrary
Library    RequestsLibrary

*** Variables ***
${BASE_URL}    https://www.jimms.fi/fi/Product/
@{CATEGORIES}    Tietokoneet    Komponentit    Oheislaitteet    SimRacing    Verkkotuotteet    Tarvikkeet    Erikoistuotteet    Ohjelmistot
${BROWSER}    Chrome

*** Test Cases ***
Verify All Product Categories Have Landing Pages And Add To Cart Button And Icon
    [Documentation]    This test case verifies that all product categories return a valid landing page and contain the addto-cart-wrapper and its icon.
    Create Session    jimms    ${BASE_URL}
    Open Browser    ${BASE_URL}    ${BROWSER}

    FOR    ${category}    IN    @{CATEGORIES}
        ${category_url}    Set Variable    ${BASE_URL}${category}

        # Navigate to the category page
        Go To    ${category_url}

        # Check for addto-cart-wrapper button presence
        Element Should Be Visible    xpath=//*[@class='addto-cart-wrapper']    msg=Add to cart button not found for ${category}.

        # Check for "Lisää koriin" button presence
        Element Should Be Visible    xpath=//*[@class='btn btn-success btn-icon js-cart-btn' and @title='Lisää koriin']    msg="Lisää koriin" button not found for ${category}.

        # Scroll to the "Lisää koriin" button to make it visible
        Scroll Element Into View    xpath=//*[@class='btn btn-success btn-icon js-cart-btn' and @title='Lisää koriin']

        # Check for the icon associated with "Lisää koriin" button
        ${icon_element}=    Get WebElement    xpath=//*[@class='material-icon me-1']
        Element Should Be Visible    ${icon_element}    msg=Icon for "Lisää koriin" not found for ${category}.

        # Take a screenshot of the icon
        Capture Element Screenshot    ${icon_element}    icon_screenshot_${category}.png

        # Sleep to prevent looping too fast
        Sleep    2

    END

    Close Browser
