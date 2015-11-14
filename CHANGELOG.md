# Changelog

## ae0007b
- Scrapes resource
    * There is now a `scrapes` table in database
    * A form for only creating scrapes exists
    * The form allows a spreadsheet to be selected for the scrape
    * The form has no validations yet
    * No EDIT or UPDATE functionality exists
    * Probably don't need to edit a scrape, just delete it
    * Unwired button for upload scrape data to spreadsheet
    * There is an association for `scrape belongs_to spreadsheet`
    * There is an association for `spreadsheet has_many scrapes`
    * For now the scrape happens as a hardcoded url in the `create` action of the `scrapes_controller`
    * Scrape data is stored as JSON and serialization is handled completely by the model
    * QuoraTask now has a `scrape` method where all scraping is done
    * `QuoraTask#scrape` returns a hash of the scraped data
    * Format for the scraped data hash is still undecided
    * Scrape index/show view have a `Show Data` link with jQuery show/hide
    * Scrape views data is preformatted and prettified with `JSON#pretty_generate`
    * jQuery for show/hide scrape data animation lives in `scrapes.js`

## 86c5013
- Spreadsheets resource
    * There is now a `spreadsheets` table in database
    * A form for creating and editing spreadsheets exists
    * The form validates a spreadsheet key through the Google API
    * The form does NOT validate the data and map worksheet GIDs
    * However, it only allows them to be set from a dropdown generated from the referenced spreadsheet from the Google API once the key has been persisted
    * Spreadsheets all have edit and delete links
    * Spreadsheets all have links to the relevant Google Docs