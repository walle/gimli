Changelog
=========

0.3.0
-----

* Remove flags for table of contents and page numbering. Add flag for wkhtmltopdf parameters instead to give more flexibility.

**This version changes the way you use gimli if you are using the -t or
-p flags. Use the -w flag instead to send the parameters directly to
wkhtmltopdf.**

0.2.3
-----

* Bugfix: Transcode to ISO-8859-1 in 1.9 also (@svendahlstrand)
* Add support for table of contents
* Bugfix: Fix incompatible character encodings with code fragments
  (@ebeigarts)
* Remove warning of iconv being depricated

0.2.2
-----

* Add support for printing out page numbers

0.2.1
-----

* Add the ability to remove yaml front matter from documents before they are converted (@clowder)


