# Create Template for Quarto Markdown

This function creates a HTML or Word template in the current working
directory using a specified Quarto extension. It copies the template
files to the `_extensions/` directory and generates a new Quarto
markdown (.qmd) file.

## Usage

``` r
create_markdown(file_name = NULL, directory = "reports", ext_name = "html")
```

## Arguments

- file_name:

  A string. The name of the new Quarto markdown (.qmd) file. This must
  be provided.

- directory:

  A string. The name of the directory to plate the files. Default is
  NULL. Requires user specification

- ext_name:

  A string. The extension type to create. Default "html" (alternatives:
  "word").

## Details

Adapted from create_template from
<https://github.com/The-Kids-Biostats/thekidsbiostats>.

The function first checks whether a `_extensions/` directory exists in
the current working directory. If not, it creates one. It then copies
the necessary extension files from the package's internal data to the
`_extensions/` directory. Finally, it creates a new Quarto markdown file
based on the extension template.

By default, the `reports` folder will be selected to house the report.

For more details, see the
[vignette](https://dempz.github.io/WAACHShelp/articles/create_markdown.html).

## Note

The function assumes that the package `WAACHShelp` contains the
necessary extension files under `ext_qmd/_extensions/`.

## Examples

``` r
if (FALSE) { # \dontrun{
create_markdown(file_name = "my_doc", ext_name = "word")
} # }
```
