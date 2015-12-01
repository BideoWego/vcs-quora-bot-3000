# DOCS

<a href="http://vcs-quora-bot-3000.herokuapp.com" target="_blank">
  Heroku
</a>

<a href="https://docs.google.com/document/d/1dr07qxwcgumADthS6ph5fJ0olftSyQItp63-naFt5HQ/edit?ts=56425b49" target="_blank">
  Specifications
</a>

<a href="https://docs.google.com/spreadsheets/d/1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc/edit?ts=56425c13#gid=0" target="_blank">
  Analytics - (REAL SPREADSHEET)
</a>


Real Spreadsheet URL and ID

```
https://docs.google.com/spreadsheets/d/1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc/edit?ts=56425c13#gid=0

key:        1hgqLdmi1830DXiwSbT1IcSPVkTp4zn_HxKB7zo-7tzc
data_gid:   0
map_gid:    N/A
```

<a href="https://github.com/gimite/google-drive-ruby" target="_blank">
  Google Drive Gem
</a>

<a href="http://gimite.net/doc/google-drive-ruby/" target="_blank">
  Google Drive Gem API Documentation
</a>

<a href="https://docs.google.com/spreadsheets/d/1cObJm4eFx1oYjMRzgNsgEymoQa6J0oWBUVW2yIRcpVo/edit#gid=872208525" target="_blank">
  Sandbox Spreadsheet (TEST SPREADSHEET)
</a>

Sandbox Spreadsheet URL and ID

```
https://docs.google.com/spreadsheets/d/1cObJm4eFx1oYjMRzgNsgEymoQa6J0oWBUVW2yIRcpVo/edit#gid=872208525

key:        1cObJm4eFx1oYjMRzgNsgEymoQa6J0oWBUVW2yIRcpVo
data_gid:   0 
map_gid:    872208525
```


----

# Proposed Ideas/Brainstorming

## General

- Simple table showing differences in stats between dates
- Scrapes may occur daily, however emails will be weekly
- Since this is a web app, email summary should provide summary of last week, but also have a link to page showing same or expanded details of that week
- Top level view with totals (dashboard welcome)
- Form to easily add/remove tags that are searched for in posts?
- The state of spreadsheet in Google Drive should always be the most up-to-date
- We could implement a check to verify a scrape return desired data before overwritting google spreadsheet

## Scraping

- Scrape with (choose spreadsheet dropdown) i.e.(X data worksheet and Y map worksheet) (named range functionality)
- Show urls that will be scraped before scraping
- Show scrape progress (AJAX)
- Show scrape results before saving to Google doc??












