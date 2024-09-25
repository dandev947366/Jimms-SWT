# Assignment 5
# Class: Software Testing
# Professor: Esa Huiskonen
# Student: Dan Le
# Team : 4

*** Settings ***
Library    RequestsLibrary
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}                https://www.jimms.fi/fi/Product/
@{CATEGORIES}             Tietokoneet    Komponentit    Oheislaitteet    SimRacing    Verkkotuotteet    Tarvikkeet    Erikoistuotteet    Ohjelmistot
${BROWSER}                Chrome
${PRODUCT_LINK_SELECTOR}   xpath=//*[@id="jim-main"]/div[2]/div/div[2]/div[4]/div/div[2]/product-box/div[2]/div[2]/h5/a
${ADD_TO_CART_BUTTON_SELECTOR}   css:.js-cart-btn
${PRODUCT_PRICE_SELECTOR}  css:.price.price--sale-colored

*** Test Cases ***
Verify All Product Categories Have Landing Pages
    [Documentation]    This test case verifies that all product categories return a valid landing page, opens the browser to display each page, and takes a screenshot.
    Create Session    jimms    ${BASE_URL}
    Open Browser    ${BASE_URL}    ${BROWSER}

    FOR    ${category}    IN    @{CATEGORIES}
        ${category_url}    Set Variable    ${BASE_URL}${category}

        # Navigate to the category page
        Go To    ${category_url}

        # Verify the response status code
        ${response}=    GET On Session    jimms    ${category}
        Run Keyword And Ignore Error    Should Be Equal As Numbers    ${response.status_code}    200    msg=Landing page for ${category} did not return a 200 status.

        # Wait for the product list container to load
        Wait Until Element Is Visible    ${PRODUCT_LINK_SELECTOR}    timeout=10s

        # Get the product link
        ${product_link}=    Get WebElement    ${PRODUCT_LINK_SELECTOR}
        ${link_text}=       Get Text    ${product_link}
        Log    Product link text is: ${link_text}

        # Verify Add to Cart button
        ${add_to_cart}=    Get WebElement    ${ADD_TO_CART_BUTTON_SELECTOR}
        Element Should Be Visible    ${add_to_cart}
        Sleep    2s

        # Verify product price
        ${price}=    Get WebElement    ${PRODUCT_PRICE_SELECTOR}
        Should Not Be Empty    ${price.text}    msg=Product price is missing in ${category}
        Sleep    2s

        # Take a screenshot of the landing page
        Capture Page Screenshot    ${category}_landing_page.png

        # Wait for 2 seconds before proceeding to the next category
        Sleep    2s
    END

    Close Browser
