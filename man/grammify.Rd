% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timeseries.R
\name{grammify}
\alias{grammify}
\title{Create a Grammian Angular Field representation of a time series}
\usage{
grammify(x)
}
\arguments{
\item{x}{the univariate timeseries to convert}
}
\value{
a matrix representing the Grammian Angular Field
}
\description{
This function takes a univariate timeseries and turns it into a Grammian
Angular Field which is a 2 dimensional representation of that time series.
Typically this could be used by a convulutional neural network to infer
properties of the problem and use it in predictive purposes.
}
\examples{
library(datools)
x <- sin(1:100)
xg <- grammify(x)
image(xg)

image(grammify(cos(1:100)))
image(grammify(sin(1:100/10)))
image(grammify(tanh(-50:50/20)))

x <- (seq(-100, 100, length.out=100)/10)^2+rnorm(100, 0, 10)
image(grammify(x))
}
