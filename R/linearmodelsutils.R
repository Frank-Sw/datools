#' Calculate the VIF for data
#'
#' Calculate the Variance Inflation Factor for a dataset.
#'
#' @param mod the data to process
#' @return A matrix containing the VIF and standardised VIF factors
#' @export
#' @examples
#' library(MASS)
#' data("birthwt")
#' vif(lm(bwt~low+smoke+age+race, data=birthwt))
#' vif(birthwt)
vif <- function(mod) UseMethod("vif")

#' @export
#' @method vif lm
vif.lm <- function(mod) vif.default(mod)

#' @export
#' @method vif data.frame
#' @importFrom stats as.formula coef coefficients cov2cor lm model.matrix vcov
vif.data.frame <- function(mod, ...){
  mod <- cbind(dummyResponse = 1, mod)
  my_formula <- as.formula(mod)
  mod <- lm(my_formula, data = mod)
  vif.default(mod)
}

vif.default <- function (mod)
{
  if (any(is.na(coef(mod))))
    stop("there are aliased coefficients in the model")
  v <- vcov(mod)
  assign <- attr(model.matrix(mod), "assign")
  if (names(coefficients(mod)[1]) == "(Intercept)") {
    v <- v[-1, -1]
    assign <- assign[-1]
  }
  else warning("No intercept: vifs may not be sensible.")
  terms <- labels(terms(mod))
  n.terms <- length(terms)
  if (n.terms < 2)
    stop("model contains fewer than 2 terms")
  R <- cov2cor(v)
  detR <- det(R)
  result <- matrix(0, n.terms, 3)
  rownames(result) <- terms
  colnames(result) <- c("GVIF", "Df", "GVIF^(1/(2*Df))")
  for (term in 1:n.terms) {
    subs <- which(assign == term)
    result[term, 1] <- det(as.matrix(R[subs, subs])) * det(as.matrix(R[-subs,
                                                                       -subs]))/detR
    result[term, 2] <- length(subs)
  }
  #if (all(result[, 2] == 1))
  #  result <- result[, 1]
  #else
  result[, 3] <- result[, 1]^(1/(2 * result[, 2]))
  result
}


