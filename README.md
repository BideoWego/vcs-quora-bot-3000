# Viking Code School | QuoraBot3000

by [Trevor Elwell](https://github.com/telwell) and [BideoWego](https://github.com/BideoWego)

A Quora web scraper

Project for [Viking Code School](http://vikingcodeschool.com)

# Initial Setup
In order to use this scraper you will need Google Developers OAuth 2.0 API credentials. These credentials consist of a `CLIENT_ID` and a `CLIENT_SECRET`. These are relatively easy to obtain but the third thing you will need, the `ACCESS_TOKEN` is a little bit more interesting to receive. This section details the instructions to obtain all of this information. 

**Firstly** you'll want to head over to [Google's Developer Center](https://developers.google.com/drive/web/auth/web-server) where you can follow the instructions to receive credentials for a Google Developers OAuth 2.0 API project. Start at [your console](https://console.developers.google.com/flows/enableapi?apiid=drive&credential=client_key) and follow the prompts to receive your own OAuth 2.0 client ID and client secret. The name of the application doesn't matter and if you get asked the `Application Type` simply select `Other`.

----

<p style="color:red;">The below instructions are also available in an in-app walk through on the Setup page.</p>

----

# Data/Map Worksheets
The app pulls urls from and populates the data worksheet dynamically by way of the map worksheet. To see an example of how to format your map worksheet visit this [link](https://docs.google.com/spreadsheets/d/1cObJm4eFx1oYjMRzgNsgEymoQa6J0oWBUVW2yIRcpVo/edit#gid=872208525).

This allows the QuoraBot to know the starting row and column of the needed named ranges. It is also recommended that you use the [sandbox spreadsheet](https://docs.google.com/spreadsheets/d/1cObJm4eFx1oYjMRzgNsgEymoQa6J0oWBUVW2yIRcpVo/edit#gid=0&vpid=A1) to get a feel for the app before attempting to use it on a master spreadsheet.

NOTE: The `Key` column of the map worksheet represents hard coded keys and is NOT dynamic. DO NOT CHANGE!

# App Setup and Settings
The root path of the app will take you to the `/setup` view. You will be prompted to enter your `CLIENT_ID` and `CLIENT_SECRET` in the settings form.

Once you have saved those credentials, navigating back to `/setup` will display another prompt to follow a link. This link will send a OAuth request to Google to grant access to your Google Drive and Spreadsheets. **Make sure if you have multiple Google accounts you choose the right one!**

After selecting an account and allowing access you will be redirected to a page with a token. Copy and paste this token into the form in the `/setup` view where it says **Redirect Token**. Once you submit that form you should see a message that Google Drive access is verified.

# Scraping the Data
The first thing you'll want to do is link the application to your spreadsheet. In the spreadsheet index view click the `Link New Local Spreadsheet Reference` button. On this form, simply enter in the Spreadsheet Key for your particular spreadsheet.

Don't know your key? Take a look at [this](http://www.coolheadtech.com/blog/use-data-from-other-google-spreadsheets) blog post for more info. There is also a detailed walk through on the `/setup` page for getting the key and GID from a spreadsheet/worksheet url.

Once your spreadsheet is set, you're ready to scrape.

# Scraping
Once your spreadsheet is linked and your map worksheet points to the correct rows and columns you're ready to scrape.

Select `Scrapes` from the navigation bar and then select `New Scrape`. Choose the spreadsheet you'd like to use to scrape and then hit the `Create Scrape!` button. You will have a scrape with no data associated with it!

In order to scrape the data you need to run a rake task. The easiest way to do this is to, in terminal, run `rake scrape:quora` (or `heroku run rake scrape:quora` on Heroku) this will likely take a few minutes. You can monitor progress in the console.

Once it's complete, you should be able to view the scrape information on the Heroku application by clicking `Show Data` on the scrape index page. If you're satisfied with the data your can then select `Upload Scrape Data to Spreadsheet` to bring this data to the actual spreadsheet. Then we're *good to go*!

Also note that if you wish to run the entire task (scrape and upload) on a schedule use `rake scrape:auto`. This will scrape then upload without the need of clicking the button in the UI.

# Final Thoughts
The gem that we used to setup the Google Drive API made it kind of a pain to get the token data, our apologies. In future iterations we'd like to make this a lot easier but for now this process definitely works. Enjoy your scraping!

**-Chris & Trevor**

