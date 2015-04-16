# gimli – utility for converting markup to pdf

[![](https://secure.travis-ci.org/walle/gimli.png)](http://travis-ci.org/walle/gimli)

## Description

Gimli is a utility for converting markup to pdf files. Useful for reports and such things.
It’s a developed version of [textile2pdf](https://github.com/walle/textile2pdf) to support multiple markup styles and to get syntax highlighting.

It’s inspired by the markup convertion in [gollum](https://github.com/github/gollum). The markup code is adapted from gollum.
It works by converting the markup to pdf using [wkhtmltopdf](https://github.com/antialize/wkhtmltopdf)
The markup is converted to html using [github/markup](https://github.com/github/markup)

### Markup

Markup files may be written in any format supported by GitHub-Markup (except roff).

### Images

Images can be included by absolute url on your hard drive or a absolute url on the Internet. You can also refer to an image relative from the markup file. Example in textile.

<pre>
!/tmp/test.jpg!
!http://upload.wikimedia.org/wikipedia/en/b/bc/Wiki.png!
!../images/test.jpg!
</pre>

## Installation

The best way to install Gimli is with RubyGems:

    $ [sudo] gem install gimli

You can install from source:

```
$ cd gimli/
$ bundle
$ rake install
```

## Running

The standard way to run gimli is to go to a folder with markup files and running

    $ gimli

To apply some style to the pdf or override the standard style add a css file in the directory named `gimli.css` or use the `-s` flag to point out another css file.

Standard behavior is for gimli to output the files in the current directory. To override this use the `-o` flag to point out another output directory. Gimli tries to create it if it doesn’t exist.

Gimli also plays nice with Jekyll style markup files. You can pass gimli the `-y` flag to have it remove Jekyll’s YAML front matter from the top of your markup files. Allowing you to use gimli & Jekyll together on your Blog/Resume/Catalogue to create nicely formatted versions for online and offline viewing.

To pass parameters directly to wkhtmltopdf, use the `-w` flag. eg.

    $ gimli -f test.md -w '--toc --footer-right "[page]/[toPage]"'

This gives a pdf with a table of contents and page numbers in the footer.

See the [man page](http://wkhtmltopdf.org/usage/wkhtmltopdf.txt) for wkhtmltopdf for all possible parameters.

Run `gimli -h` for a full list of options available

### Gimli Docker Container

There is a Docker container to use for converting files using gimli without installing gimli to your computer, you can see more about it at https://registry.hub.docker.com/u/walle/gimli/

#### Running the image

    $ docker run -v <host_dir>:<container_dir> walle/gimli -f <container_dir>/my-file.md -o <container_dir>

Where `<host_dir>` is the directory with the files you want to convert and `<container_dir>` is the directory in the image where the files will be put. This will write the pdf files to the same directory as where your source files is. If you want to make a new directory for the pdfs you can call the image like this:

    $ docker run -v <host_dir>:<container_dir> walle/gimli -f <container_dir>/my-file.md -o <container_dir>/pdfs

This will put the pdfs in a folder named pdfs in your `<host_dir>`.

##### A real example

    $ docker run -v /home/walle/gimlidocuments:/tmp/gimli walle/gimli -f /tmp/gimli/my-file.md -o /tmp/gimli

This will generate a pdf from the file in `/home/walle/gimlidocuments/my-file.md` in the `/home/walle/gimlidocuments` directory.

##### Arguments

All arguments you supply to running the image will end up in gimli, so for an example you could supply the `-s` flag to use a custom stylesheet. But the stylesheet must be in `<host_dir>` to be readable by gimli.

## Syntax highlighting

In page files you can get automatic syntax highlighting for a wide range of languages by using the following syntax:

    ```ruby
      def foo
        puts 'bar'
      end
    ```

The block must start with three backticks (as the first characters on the line). After that comes the name of the language that is contained by the block. The language must be one of the short name lexer strings supported by coderay. See the list of lexers for valid options.

If the block contents are indented two spaces or one tab, then that whitespace will be ignored (this makes the blocks easier to read in plaintext).

The block must end with three backticks as the first characters on a line.

The syntax highlightning is powered by [coderay](https://github.com/rubychan/coderay) and is using a [github theme](https://github.com/pie4dan/CodeRay-GitHub-Theme).