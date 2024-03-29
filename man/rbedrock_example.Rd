% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/example.R
\name{rbedrock_example}
\alias{rbedrock_example}
\alias{rbedrock_example_world}
\title{Get path to rbedrock example}
\usage{
rbedrock_example(path = NULL)

rbedrock_example_world(path)
}
\arguments{
\item{path}{Name of file or directory. If \code{NULL}, the examples will be
listed.}
}
\description{
rbedrock comes bundled with a number of sample files in its \code{inst/extdata}
directory. This function make them easy to access.
}
\examples{
rbedrock_example()
rbedrock_example("example1.mcworld")
rbedrock_example_world("example1.mcworld")
}
