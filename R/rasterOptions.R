# Author: Robert J. Hijmans
# September 2009
# Version 1.0
# Licence GPL v3


rasterOptions <- function(format, overwrite, datatype, tmpdir, tmptime, progress, timer, chunksize, maxmemory, todisk, setfileext, tolerance, standardnames, depracatedwarnings, default=FALSE, save=FALSE) {
	
	
	
	setFiletype <- function(format) {
		if (.isSupportedFormat(format)) {	
			options(rasterFiletype = format)	
		} else { 
			warning(paste('Cannot set filetype to unknown or unsupported file format:', format, '. See writeFormats()'))
		}
	}
	
	setOverwrite <- function(overwrite) {
		if (is.logical(overwrite)) { 
			options(rasterOverwrite = overwrite)
		} else { 
			warning(paste('Could not set overwrite. It must be a logical value'))
		}
	}
	
	setDataType <- function(datatype) {
		if (datatype %in% c('LOG1S', 'INT1S', 'INT2S', 'INT4S', 'INT4U', 'INT1U', 'INT2U', 'FLT4S', 'FLT8S')) {	
			options(rasterDatatype = datatype)
		} else { 
			warning(paste('Cannot set datatype to unknown type:',datatype))	
		}
	}
	
	setTmpdir <- function(tmpdir) {
		if (!missing(tmpdir)) {
			tmpdir <- trim(tmpdir)
			if (tmpdir != '') {
				lastchar = substr(tmpdir, nchar(tmpdir), nchar(tmpdir))
				if (lastchar != "/" & lastchar != '\\') {
					tmpdir <- paste(tmpdir, '/', sep='')
				}		
				res <- file.exists(substr(tmpdir, 1, nchar(tmpdir)-1))
				if (!res) { 
					res <- dir.create(tmpdir, recursive=TRUE, showWarnings = FALSE) 
				}
				if (res) { 
					options(rasterTmpDir = tmpdir) 
				} else { 
					warning(paste('could not create tmpdir:',tmpdir))	
				}
			}
		}
	}
	
	setTmpTime <- function(tmptime) {
		if (is.numeric(tmptime)) {
			if (tmptime > 1) {
				options(rasterTmpTime = tmptime)
			} else {
				warning(paste('Could not set tmptime. It must be > 1'))	
			}
		} else {
			warning(paste('Could not set tmptime. It must be a numerical value'))	
		}
	}

	setProgress <- function(progress) {
		if (is.character(progress)) {
			progress <- tolower(trim(progress))
			if (progress %in% c('window', 'tcltk', 'windows')) { progress <- 'window' }
			if (! progress %in% c('text', 'window', '')) { 
				warning('invalid value for progress. Should be "window", "text", or ""')
			} else {
				options(rasterProgress = progress )
			}
		} else {
			warning('progress must be a character value')
		}
	}
	
	setTimer <- function(timer) {
		if (is.logical(timer)) {
			options(rasterTimer = timer )
		} else {
			warning(paste('timer must be a logical value'))	
		}
	}
	
	
	setToDisk <- function(todisk) {
		if (is.logical(todisk)) { 
			options(rasterToDisk = todisk )
		} else {
			warning(paste('todisk argument must be a logical value'))	
		}
	}
 
	setChunksize <- function(chunksize) {
		chunksize <- max(1, round(chunksize[1]))
		chunksize <- min(chunksize, 10^9)
		options(rasterChunkSize = chunksize )
	}

	setFileExt <- function(setfileext) {
		options(rasterSetFileExt = as.logical(setfileext) )
	}

	setMaxMemorySize <- function(maxmemory) {
		maxmemory = max(10000, round(maxmemory[1]))
		options(rasterMaxMemory = maxmemory )
	}
	
	setTolerance <- function(x) {
		x <- max(0.000000001, min(x, 0.5))
		options(rasterTolerance = x)
	}
	
	setStandardNames <- function(x) {
		if (is.logical(x)) {
			if (is.na(x)) {
				x <- TRUE
			}
			options(rasterStandardNames = x)
		}
	}
		
	depracatedWarnings <- function(x) {
		if (is.logical(x)) {
			if (is.na(x)) {
				x <- TRUE
			}
			options(rasterDepracatedWarnings = x)
		}
	}
	
	cnt <- 0
	if (default) {
		cnt <- 1
		options(rasterFiletype = 'raster')
		options(rasterOverwrite = FALSE)
		options(rasterDatatype = 'FLT4S')
		options(rasterProgress = 'none')
		options(rasterTimer = FALSE)
		options(rasterTmpDir = .tmpdir())
		options(rasterTmpTime = 24*7)
		options(rasterToDisk = FALSE)
		options(rasterSetFileExt = TRUE)
		options(rasterChunkSize = 1000000)
		options(rasterMaxMemory = 10000000)
		options(rasterTolerance = 0.1)
		options(rasterStandardNames = TRUE)
		options(rasterDepracatedWarnings = TRUE)
	}

	
	if (!missing(format)) { setFiletype(format); cnt <- cnt+1 }
	if (!missing(overwrite)) { setOverwrite(overwrite); cnt <- cnt+1 }
	if (!missing(datatype)) { setDataType(datatype); cnt <- cnt+1 }
	if (!missing(progress)) { setProgress(progress); cnt <- cnt+1 }
	if (!missing(timer)) { setTimer(timer); cnt <- cnt+1 }
	if (!missing(tmpdir)) { setTmpdir(tmpdir); cnt <- cnt+1 }
	if (!missing(tmptime)) { setTmpTime(tmptime); cnt <- cnt+1 }
	if (!missing(todisk)) { setToDisk(todisk); cnt <- cnt+1 }
	if (!missing(setfileext)) { setFileExt(setfileext); cnt <- cnt+1 }
	if (!missing(maxmemory)) { setMaxMemorySize(maxmemory); cnt <- cnt+1 }
	if (!missing(chunksize)) { setChunksize(chunksize); cnt <- cnt+1 }
	if (!missing(tolerance)) { setTolerance(tolerance); cnt <- cnt+1 }
	if (!missing(standardnames)) { setStandardNames(standardnames); cnt <- cnt+1 }
	if (!missing(depracatedwarnings)) { depracatedWarnings(depracatedwarnings); cnt <- cnt+1 }


	lst <- list(
		format=.filetype(),
		overwrite=.overwrite(),
		datatype=.datatype(),
		tmpdir=.tmpdir(),
		tmptime=.tmptime(),
		progress=.progress(),
		timer=.timer(),
		chunksize=.chunksize(),
		maxmemory=.maxmemory(),
		todisk=.toDisk(),
		setfileext=.setfileext(),
		tolerance=.tolerance(),
		standardnames=.standardnames(),
		depwarning=.depracatedwarnings()
	)
	
	if (save) {
	
		fn <- paste(R.home(component="etc"), '/', 'Rprofile.site', sep='')
		if (file.exists(fn)) {
			oplst <- readLines(fn)
			if (length(oplst) == 0) { 
				oplst <- "" 
			}
			oplst <- .removeRasterOptions(oplst)
			if (oplst[length(oplst)] != "") { 
				oplst <- c(oplst, "") 
			}
		} else {
			oplst <- ""
		}

		cnt <- 1
		oplst <- c(oplst, "# Options for the 'raster' package")
		oplst <- c(oplst, paste("options(rasterFiletype='", lst$format, "')", sep='')) 
		oplst <- c(oplst, paste("options(rasterOverwrite=", lst$overwrite, ')', sep=''))
		oplst <- c(oplst, paste("options(rasterDatatype='", lst$datatype, "')", sep=''))
		oplst <- c(oplst, paste("options(rasterTmpDir='", lst$tmpdir, "')", sep=''))
		oplst <- c(oplst, paste("options(rasterTmpTime='", lst$tmptime, "')", sep=''))
		oplst <- c(oplst, paste("options(rasterProgress='", lst$progress, "')", sep=''))
		oplst <- c(oplst, paste("options(rasterTimer=", lst$timer, ')', sep=''))
		oplst <- c(oplst, paste("options(rasterChunkSize=", lst$chunksize, ")", sep=''))
		oplst <- c(oplst, paste("options(rasterMaxMemory=", lst$maxmemory, ")", sep=''))
		oplst <- c(oplst, paste("options(rasterSetFileExt=", lst$setfileext, ')', sep=''))
		oplst <- c(oplst, paste("options(rasterTolerance=", lst$tolerance, ')', sep=''))
		oplst <- c(oplst, paste("options(rasterStandardNames=", lst$standardnames, ')', sep=''))
		oplst <- c(oplst, paste("options(rasterDepracatedWarnings=", lst$depwarning, ')', sep=''))
		
		r <- try( write(unlist(oplst), fn), silent = TRUE )
		if (class(r) == "try-error") { 
			warning('Cannot save options. No write access to: ', fn, '\n')	
		}
	}	
	
	
	if (cnt == 0) {
		cat('format        :', lst$format, '\n' )
		cat('datatype      :', lst$datatype, '\n')
		cat('overwrite     :', lst$overwrite, '\n')
		cat('progress      :', lst$progress, '\n')
		cat('timer         :', lst$timer, '\n')
		cat('chunksize     :', lst$chunksize, '\n')
		cat('maxmemory     :', lst$maxmemory, '\n')
		cat('tmpdir        :', lst$tmpdir, '\n')
		cat('tmptime       :', lst$tmptime, '\n')
		cat('setfileext    :', lst$setfileext, '\n')
		cat('tolerance     :', lst$tolerance, '\n')
		cat('standardnames :', lst$standardnames, '\n')
		cat('warn depracat.:', lst$depwarning, '\n')
		if (lst$todisk) {
		   cat('todisk       : TRUE\n')
		}
	}
	
	invisible(lst)
}


.depracatedwarnings <- function() {
	d <- getOption('rasterDepracatedWarnings')
	if (is.null(d)) {
		return( TRUE )
	} 
	return(as.logical(d))
}



.dataloc <- function() {
	d <- getOption('rasterDataDir')
	if (is.null(d) ) {
		d <- getwd()
	} else {
		d <- trim(d)
		if (d=='') {
			d <- getwd()
		}
	}
	return(d)
}	


.tmpdir <- function(create=TRUE) {
	d <- getOption('rasterTmpDir')
	if (is.null(d)) {
		d <- .tmppath()
	}
	lastchar <- substr(d, nchar(d), nchar(d))
	if (lastchar == '/' | lastchar == '\\') {
		dd <- substr( d, 1, nchar(d)-1 )
	}
	if (!file.exists(dd)) {
		if (create) {
			d <- .tmppath()
			dir.create( d, recursive=TRUE, showWarnings=FALSE )
		} else {
			return(NA)
		}
	}
	return(d)
}



.chunksize <- function(){
	default <- 1e+07
	d <- getOption('rasterChunkSize')
	if (is.null(d)) {
		return( default )
	} 
	d <- round(as.numeric(d[1]))
	if (is.na(d) | d < 10000) {
		d <- default
	} 
	return(d)
}	



.setfileext <- function() {
	d <- getOption('rasterSetFileExt')
	if (is.null(d)) {
		return( TRUE )
	} 
	return(as.logical(d))
}	



.tmptime <- function() {
	d <- getOption('rasterTmpTime')
	if (is.null(d)) {
		d <- 24 * 7
	} else {
		d <- as.numeric(d)
		if (d < 0) {
			d <- 24 * 7
		}
	}
	return(d)
}	




.maxmemory <- function() {
	default <- 1e+08
	d <- getOption('rasterMaxMemory')
	if (is.null(d)) {
		return( default )
	} 
	d <- round(as.numeric(d[1]))
	if (is.na(d) | d < 10000) {
		d <- default
	} 
	return(d)
}


.tolerance <- function() {
	d <- getOption('rasterTolerance')
	if (is.null(d)) {
		d <- 0.1
	} else {
		d <- max(0.000000001, min(d, 0.5))
	}
	return(d)
}


.overwrite <- function(..., overwrite) {
	if (missing(overwrite)) { 
		overwrite <- getOption('rasterOverwrite')
		if (is.null(overwrite)) {
			return(FALSE)
		} else {
			if (is.logical(overwrite)) {
				return(overwrite)
			} else {
				return(FALSE)
			}
		}
	} else { 
		if (is.logical(overwrite)) {
			return(overwrite)
		} else {
			return(FALSE)
		}
	}
}


.datatype <- function(..., datatype) {
	if (missing(datatype)) { 
		datatype <- getOption('rasterDatatype')
		if (is.null(datatype)) {
			return('FLT4S') 
		} 
	} 
	if (! datatype %in% c('LOG1S', 'INT1S', 'INT2S', 'INT4S', 'INT1U', 'INT2U', 'INT4U', 'FLT4S', 'FLT8S')) {
		warning(datatype, ' is an invalid datatype, changed to "FLT8S"')
		datatype <- 'FLT8S'
	}
	return(datatype)
}

.getFormat <- function(filename) {
	ext <- tolower(extension(filename, maxchar=5))
	if (nchar(ext) < 3) {
		return('')
	} else {
		if (ext == '.tif' | ext == '.tiff') { return('GTiff')
		} else if (ext == '.grd') { return('raster')
		} else if (ext == '.asc') { return('ascii')
		} else if (ext == '.nc' | ext == '.cdf' | ext == '.ncdf') { return('CDF')
		} else if (ext == '.kml') { return('KML')
		} else if (ext == '.kmz') { return('KML')		
		} else if (ext == '.big') { return('big.matrix')
		} else if (ext == '.sgrd') { return('SAGA')
		} else if (ext == '.sdat') { return('SAGA')
		} else if (ext == '.bil') { return('BIL')
		} else if (ext == '.bsq') { return('BSQ')
		} else if (ext == '.bip') { return('BIP')
		} else if (ext == '.bmp') { return('BMP') 
		} else if (ext == '.gen') { return('ADRG') 
		} else if (ext == '.bt') { return('BT') 
		} else if (ext == '.envi') { return('ENVI')
		} else if (ext == '.ers') { return('ERS') 
		} else if (ext == '.img') { return( 'HFA') 
		} else if (ext == '.rst') { return('RST') 
		} else if (ext == '.mpr') { return('ILWIS')
		} else if (ext == '.rsw') { return('RMF')
		} else { 
			warning('extension ', ext, ' is unknown. Using default format.')
			return('') 
		}
	}
	
}


.filetype <- function(format, filename='', ...) {
	if (missing(format)) { 
		format <- .getFormat(filename)
		if (format != '') {
			return(format)
		}
		
		format <- getOption('rasterFiletype')
		if (is.null(format)) {
			return('raster') 
		} else {
			return(format)
		}
		
	} else { 
		return(format)
	}
}

.progress <- function(..., progress) {
	if (missing(progress)) { 
		progress <- getOption('rasterProgress')
		if (is.null(progress)) {
			return('none') 
		} else {
			if (is.character(progress)) {
				if (progress[1] %in% c('text', 'window', 'tcltk', 'windows')) {
					return(progress[1])
				} else {
					return('none')
				}
			} else {
				return('none')
			}
		}
	} else { 
		if (is.character(progress)) {
			if (progress[1] %in% c('text', 'window', 'tcltk', 'windows')) {
				return(progress[1])
			} else {
				return('none')
			}
		} else {
			return('none')
		}
	}
}


.timer <- function(..., timer) {
	if (missing(timer)) { 
		timer <- getOption('rasterTimer')
		if (is.null(timer)) {
			return(FALSE) 
		} else {
			return( as.logical(timer) )
		}
	} else {
		return(as.logical(timer))
	}
}	
	
.standardnames <- function(..., standardnames) {
	if (missing(standardnames)) { 
		standardnames <- getOption('rasterStandardNames')
		if (is.null(standardnames)) {
			return(TRUE)  # the default
		} else {
			try (todisk <- as.logical(standardnames))
			if (is.logical(standardnames)) {
				return(standardnames)
			} else {
				return(TRUE)
			}
		}
	} else { 
		if (is.logical(todisk)) {
			return(todisk)
		} else {
			return(TRUE)
		}
	}
}
	

.toDisk <- function(..., todisk) {
	if (missing(todisk)) { 
		todisk <- getOption('rasterToDisk')
		if (is.null(todisk)) {
			return(FALSE)  # the default
		} else {
			try (todisk <- as.logical(todisk))
			if (is.logical(todisk)) {
				return(todisk)
			} else {
				return(FALSE)
			}
		}
	} else { 
		if (is.logical(todisk)) {
			return(todisk)
		} else {
			return(FALSE)
		}
	}
}


.usecluster <- function(...) {
	usecluster <- list(...)$usecluster
	if (is.null(usecluster)) { 
		usecluster <- getOption('rasterUseCluster')
		if (is.null(usecluster)) {
			return(FALSE)  # the default
		} else {
			try (usecluster <- as.logical(usecluster), silent=TRUE)
			if (isTRUE(usecluster)) {
				return(TRUE)
			} else {
				return(FALSE)
			}
		}
	} else { 
		if (is.logical(usecluster)) {
			return(usecluster)
		} else {
			return(FALSE)
		}
	}
}

.removeRasterOptions <- function(x) {
	y <- list()
	for (i in seq(along=x)) {
		if (!trim(x[[i]]) == "# Options for the 'raster' package" & !substr(trim(x[[i]]),1,14) == 'options(raster') {
			y <- c(y, x[[i]])
		}
	}
	return(y)
}
