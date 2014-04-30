# Changelog

## 0.5.3

* Merge fixes for gemfile and gitignore. Thanks @docwhat

## 0.5.0

* Support for autolinks and tables using PHP-Markdown style. This version monley patches github/markup to use redcarpet directly in order to be able to pass in extensions.

## 0.4.2

* Fix bug with wkhtmltopdf arguments not being passed to said command #38 (@apognu)
* Adds debug flag to output generated html to stdout
* Add css styling to fix issue #36

## 0.4.1

Add utf-8 meta tag to fix display of utf-8 characters

## 0.4.0

* Remove some markup gems as dependencies. Install them outside of gimli to use them. Like all other more "unkommon" markup languages.

## 0.3.2

* Code refactorings
* Removed support for gollum's "tags" eg. [[File]]. Use markup to create links

## 0.3.1

* Use coderay instead of albino and pygments. This fixes issues with
  pygments not being installed and simplifies testing.

## 0.3.0

* Remove flags for table of contents and page numbering. Add flag for wkhtmltopdf parameters instead to give more flexibility.

**This version changes the way you use gimli if you are using the -t or
-p flags. Use the -w flag instead to send the parameters directly to
wkhtmltopdf.**

## 0.2.3

* Bugfix: Transcode to ISO-8859-1 in 1.9 also (@svendahlstrand)
* Add support for table of contents
* Bugfix: Fix incompatible character encodings with code fragments
  (@ebeigarts)
* Remove warning of iconv being depricated

## 0.2.2

* Add support for printing out page numbers

## 0.2.1

* Add the ability to remove yaml front matter from documents before they are converted (@clowder)


