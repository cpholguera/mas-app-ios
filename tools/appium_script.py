#!/usr/bin/env python3
"""
This script uses Appium's Python client to:
- Connect to an Appium server and attach to a running iOS app.
- Capture a screenshot before clicking a button labeled "Start".
- Click the "Start" button.
- Capture another screenshot after clicking.
- Dump the final UI hierarchy as XML.
- Save the screenshots and XML file for further inspection.
"""


from appium import webdriver
from appium.options.ios import XCUITestOptions
import time
from appium.webdriver.common.appiumby import AppiumBy

def main():
    # Get the built app path from the environment variable.
    # app_path = os.getenv('APP_PATH')
    # options.app = app_path

    # Set up options
    options = XCUITestOptions()
    options.platform_version = "26.2"
    options.device_name = "iPhone 16"
    
    # Use the bundle identifier to attach to the running app
    options.bundle_id = "org.owasp.mastestapp.MASTestApp-iOS"
    # Prevent Appium from automatically launching the app
    options.auto_launch = False
    # Prevent Appium from resetting the app state (maybe remove)
    options.no_reset = True

    # Connect to Appium using the options parameter
    driver = webdriver.Remote("http://localhost:4723", options=options)
    driver.implicitly_wait(10)

    # Wait for the app to load.
    time.sleep(5)

    # Capture a screenshot before clicking the "Start" button.
    driver.save_screenshot("before_start.png")
    print("Saved screenshot: before_start.png")

    # Locate and click the "Start" button.
    try:
        start_button = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "Start")
        start_button.click()
        print("Clicked the 'Start' button.")
    except Exception as e:
        print(f"Error: Unable to locate or click the 'Start' button. Details: {e}")
        driver.quit()
        return

    # Wait for any UI transitions after the click.
    time.sleep(3)

    # Capture a screenshot after clicking the "Start" button.
    driver.save_screenshot("after_start.png")
    print("Saved screenshot: after_start.png")

    # Dump the final UI hierarchy as XML.
    xml_dump = driver.page_source
    with open("final_screen.xml", "w", encoding="utf-8") as f:
        f.write(xml_dump)
    print("Saved final UI dump to final_screen.xml")

    # End the Appium session.
    driver.quit()

if __name__ == '__main__':
    main()
