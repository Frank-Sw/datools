#' Find the optimal lag
#'
#' Finds the lag that maximizes the absolute correlation between two time
#' series x and y.
#'
#' @param x time series x
#' @param y time series y
#' @param lag.max the maximum number of lags to investigate which defaults to
#' the integer value of length(x)/2.
#'
#' @return an integer representign the optimal lag to apply to x
#' @importFrom tibble tibble
#' @export
#'
#' @examples
#' library(tibble)
#' library(ggplot2)
#' library(tidyr)
#' library(dplyr)
#' x <- sin(seq(1, 10, length.out = 30))
#' y <- lag(x,5) + rnorm(length(x), 0, 0.2)
#' testdf <- tibble(id=seq_along(x), x, y)
#' ggplot(gather(testdf, key, val, -id), aes(y=val, x=id, color=key)) + geom_line()
#' stats::ccf(x,y, na.action = na.omit, lag.max = 5)
#' testdf <- mutate(testdf, z=lag(x, find_lag(x,y)))
#' ggplot(gather(testdf, key, val, -id), aes(y=val, x=id, color=key)) + geom_line()
find_lag<-function(x,y, lag.max=as.integer(length(x)/2)) {
  if(length(x) != length(y)) stop("Vectors of equal length required")
  res <- stats::ccf(x, y, lag.max = lag.max, na.action = stats::na.omit, plot = FALSE)
  res$lag[which.max(abs(res$acf))]
}

#' Create a Grammian Angular Field representation of a time series
#'
#' This function takes a univariate timeseries and turns it into a Grammian
#' Angular Field which is a 2 dimensional representation of that time series.
#' Typically this could be used by a convulutional neural network to infer
#' properties of the problem and use it in predictive purposes.
#'
#' @param x the univariate timeseries to convert
#'
#' @return a matrix representing the Grammian Angular Field
#' @export
#'
#' @examples
#' library(datools)
#' x <- sin(1:100)
#' xg <- grammify(x)
#' image(xg)
#'
#' image(grammify(cos(1:100)))
#' image(grammify(sin(1:100/10)))
#' image(grammify(tanh(-50:50/20)))
#'
#' x <- (seq(-100, 100, length.out=100)/10)^2+rnorm(100, 0, 10)
#' image(grammify(x))
grammify <- function(x) {
  theta <- acos(standardize(x, -1, 1))
  outer(theta, theta, FUN=function(x, y) cos(x+y))
}
