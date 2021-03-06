\name{geom}

\docType{methods}

\alias{geom}
\alias{geom,SpatialPolygons-method}
\alias{geom,SpatialLines-method}
\alias{geom,SpatialPoints-method}
\alias{geom,data.frame-method}


\title{Get the coordinates of a vector type Spatial* object}

\description{
Extract the coordinates of a Spatial object
}

\usage{
\S4method{geom}{SpatialPolygons}(x, sepNA=FALSE, ...)
\S4method{geom}{SpatialLines}(x, sepNA=FALSE, ...)
\S4method{geom}{SpatialPoints}(x, ...)
\S4method{geom}{data.frame}(x, d, gt, crs, ...)
}

\arguments{
  \item{x}{SpatialPolygons*, SpatialLines*, or SpatialPoints* object; or a data.frame}
  \item{sepNA}{logical. If \code{TRUE}, geometries are separated by a row with \code{NA} values}
  \item{...}{additional arguments, none implemented}
  \item{d}{data.frame that matches the number of objects in data.frame \code{x}}
  \item{gt}{character. geometry type. Must be one of "polygons", "lines", "points"}
  \item{crs}{character. PROJ.4 crs string}  
}


\value{
Matrix with 6, (5 SpatialLines), or 3 (SpatialPoints) columns. object (sequential object number) part (sequential part number within the object; not for SpatialPoints), cump (cumulative part number; not for SpatialPoints), hole (is this a hole or not; only for SpatialPolygons), x (x coordinate or longitude), y (y coordinate or latitude)
}

\seealso{ \code{\link[sp]{coordinates}}, \code{\link[sp:geometry-methods]{geometry}} }


\examples{
p <- readRDS(system.file("external/lux.rds", package="raster"))
x <- geom(p)
head(x)
	
# and back to a SpatialPolygonsDataFrame	
x <- data.frame(x)
sp <- as(x, "SpatialPolygons")
crs(sp) <- crs(p)
spdf <- SpatialPolygonsDataFrame(sp, data.frame(p), match.ID=FALSE)
}

\keyword{methods}
\keyword{spatial}

