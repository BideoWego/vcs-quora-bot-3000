# Viking Code School | QuoraBot3000

by [Trevor Elwell](https://github.com/telwell) and [BideoWego](https://github.com/BideoWego)

A Quora web scraper

Project for [Viking Code School](http://vikingcodeschool.com)

# Initial Setup
In order to use this scraper you will need Google Developers OAuth 2.0 API credentials. These credentials consist of a `CLIENT_ID` and a `CLIENT_SECRET`. These are relatively easy to obtain but the third thing you will need, the `DRIVE_TOKEN_DATA` is a little bit more interesting to receive. This section details the instructions to obtain all of this information. 

**Firstly** you'll want to head over to [Google's Developer Center](https://developers.google.com/drive/web/auth/web-server) where you can follow the instructions to receive credentials for a Google Developers OAuth 2.0 API project. Start at [your console](https://console.developers.google.com/flows/enableapi?apiid=drive&credential=client_key) and follow the prompts to receive your own OAuth 2.0 client ID and client secret. The name of the application doesn't matter and if you get asked the `Application Type` simply select `Other`.

**Now for the fun stuff!**
Once you have your `CLIENT_ID` and `CLIENT_SECRET` setup you'll need to run the app locally (not on Heroku). Once it's running go to `localhost:3000/setup`. Enter your `CLIENT_ID` and `CLIENT_SECRET` into the form and submit. Then, move over to terminal and view the server output. You will see a URL to go to in order to authenticate the application. Go there, grant your application access, and then copy the code from the resulting page into the terminal input and enter.

If this went through properly you should see your `DRIVE_TOKEN_DATA` appear where the submitted form once was. The last step is to set your received values to `CLIENT_ID`, `CLIENT_SECRET`, and `DRIVE_TOKEN_DATA` as `ENV` variables on Heroku if they haven't been set already. If they have been set then just overwrite the current values. Then you should be good to go!

# Scraping the Data
The first thing you'll want to do is link the application to your spreadsheet. On the homepage of the application (on Heroku now) click the `Link New Local Spreadsheet Reference` button. On this form, simply enter in the Spreadsheet Key for your particular spreadsheet. Don't know your key? Take a look at [this](http://www.coolheadtech.com/blog/use-data-from-other-google-spreadsheets) blog post for more info. Once your spreadsheet is set, you're ready to scrape. 

Select `Scrapes` from the navigation bar and then select `New Scrape`. Choose the spreadsheet you'd like to use to scrape and then hit the `Do Scrape!` button. You will have a scrape with no data associated with it! In order to scrape the data you need to run a rake task on heroku. The easiest way to do this is to, in terminal, run `heroku run rake scrape:auto`; this will likely take a few minutes. You can monitor progress in the console. Once it's complete, you should be able to view the scrape information on the Heroku application by clicking `Show Data`. If you're satisfied with the data your can then select `Upload Scrape Data to Spreadsheet` to bring this data to the actual spreadsheet. Then we're *good to go*!

# Final Thoughts
The gem that we used to setup the Google Drive API made it kind of a pain to get the token data, our apologies. In future iterations we'd like to make this a lot easier but for now this process definitely works. Enjoy your scraping!

**-Chris & Trevor**