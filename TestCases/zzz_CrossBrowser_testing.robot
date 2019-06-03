# Deze code zorgt ervoor dat in Firefox de balk "..." niet meer wordt getoond.
    # ProfilesIni  ffProfiles = new ProfilesIni()
    # FirefoxProfile  profile = ffProfiles.getProfile("customfirefox");
    # WebDriver  driver = new FirefoxDriver(profile);

    # hrome_options = webdriver.ChromeOptions()
    # chrome_options.add_argument("--disable-infobars")
    # driver = webdriver.Chrome(chrome_options=chrome_options)

    # chrome_options = webdriver.ChromeOptions()
    # prefs = {"profile.default_content_setting_values.notifications" : 2}
    # chrome_options.add_experimental_option("prefs",prefs)
    # driver = webdriver.Chrome(chrome_options=chrome_options)

    # browser_profile = webdriver.FirefoxProfile()
    # _browser_profile.set_preference("dom.webnotifications.enabled", False)
    # webdriver.Firefox(firefox_profile=_browser_profile)

    # from selenium.webdriver.firefox.options import Options
    # options = Options()
    # options.set_preference("dom.webnotifications.enabled", False)
    # browser = webdriver.Firefox(firefox_options=options)