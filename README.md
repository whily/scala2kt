# scala2kt

An *WIP* Emacs package to convert Scala source code to Kotlin, with
very limited functionalities. The package merely replace a few Scala
syntax structures to Kotlin with regexp, instead of using AST. It is
not expected to support advanced Scala features. In summary, just
consider the package as an *assistant* to help you for the conversion,
instead of a one-stop solution.

## Installation

Clone this repository, add the path containing the package to the
`load-path` in Emacs `init.el`, as well as adding `(require
'scala2kt)`.

In the buffer containing the file for conversion, type `M-x scala2kt`.
