# Assignment 4
# Class: Software Testing
# Professor: Esa Huiskonen
# Student: Dan Le
# Team : 4
*** Settings ***
Library    RequestsLibrary
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}    https://www.jimms.fi/fi/Product/
@{CATEGORIES}    Tietokoneet    Komponentit    Oheislaitteet    SimRacing    Verkkotuotteet    Tarvikkeet    Erikoistuotteet    Ohjelmistot
${BROWSER}    Chrome

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
        
        # Take a screenshot of the landing page
        Capture Page Screenshot    ${category}_landing_page.png
        
        # Wait for 2 seconds before proceeding to the next category
        Sleep    2s
    END

    Close Browser
