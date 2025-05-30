% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/time-zones.r
\name{force_tz}
\alias{force_tz}
\alias{force_tz.default}
\alias{force_tzs}
\title{Replace time zone to create new date-time}
\usage{
force_tz(time, tzone = "", ...)

\method{force_tz}{default}(time, tzone = "", roll_dst = c("NA", "post"), roll = NULL, ...)

force_tzs(
  time,
  tzones,
  tzone_out = "UTC",
  roll_dst = c("NA", "post"),
  roll = NULL
)
}
\arguments{
\item{time}{a POSIXct, POSIXlt, Date, chron date-time object, or a data.frame
object. When a data.frame all POSIXt elements of a data.frame are processed
with \code{force_tz()} and new data.frame is returned.}

\item{tzone}{a character string containing the time zone to convert to. R
must recognize the name contained in the string as a time zone on your
system.}

\item{...}{Parameters passed to other methods.}

\item{roll_dst}{is a string vector of length one or two. When two values are
supplied they specify how to roll date-times when they fall into "skipped" and
"repeated" DST transitions respectively. A single value is replicated to the
length of two. Possible values are:

\if{html}{\out{<div class="sourceCode">}}\preformatted{* `pre` - Use the time before the transition boundary.
* `boundary` - Use the time exactly at the boundary transition.
* `post` - Use the time after the boundary transition.
* `xfirst` - crossed-first: First time which occurred when crossing the
   boundary. For addition with positive units pre interval is crossed first and
   post interval last. With negative units post interval is crossed first, pre -
   last. For subtraction the logic is reversed.
* `xlast` - crossed-last.
* `NA` - Produce NAs when the resulting time falls inside the problematic interval.
}\if{html}{\out{</div>}}

For example `roll_dst = c("NA", "pre") indicates that for skipped intervals
return NA and for repeated times return the earlier time.

When multiple units are supplied the meaning of "negative period" is determined by
the largest unit. For example \code{time_add(t, days = -1, hours = 2, roll_dst = "xfirst")} would operate as if with negative period, thus crossing the boundary
from the "post" to "pre" side and "xfirst" and hence resolving to "post"
time. As this might result in confusing behavior. See examples.

"xfirst" and "xlast" make sense for addition and subtraction only. An error is
raised if an attempt is made to use them with other functions.}

\item{roll}{deprecated, same as \code{roll_dst} parameter.}

\item{tzones}{character vector of timezones to be "enforced" on \code{time} time
stamps. If \code{time} and \code{tzones} lengths differ, the smaller one is recycled
in accordance with usual R conventions.}

\item{tzone_out}{timezone of the returned date-time vector (for \code{force_tzs}).}
}
\value{
a POSIXct object in the updated time zone
}
\description{
\code{force_tz} returns the date-time that has the same clock time as input time,
but in the new time zone. \code{force_tzs} is the parallel version of \code{force_tz},
meaning that every element from \code{time} argument is matched with the
corresponding time zone in \code{tzones} argument.
}
\details{
Although the new date-time has the same clock time (e.g. the same values in
the year, month, days, etc. elements) it is a different moment of time than
the input date-time.

As R date-time vectors cannot hold elements with non-uniform time zones,
\code{force_tzs} returns a vector with time zone \code{tzone_out}, UTC by default.
}
\examples{
x <- ymd_hms("2009-08-07 00:00:01", tz = "America/New_York")
force_tz(x, "UTC")
force_tz(x, "Europe/Amsterdam")

## DST skip:
y <- ymd_hms("2010-03-14 02:05:05 UTC")
force_tz(y, "America/New_York", roll_dst = "NA")
force_tz(y, "America/New_York", roll_dst = "pre")
force_tz(y, "America/New_York", roll_dst = "boundary")
force_tz(y, "America/New_York", roll_dst = "post")

## DST repeat
y <- ymd_hms("2014-11-02 01:35:00", tz = "UTC")
force_tz(y, "America/New_York", roll_dst = "NA")
force_tz(y, "America/New_York", roll_dst = "pre")
force_tz(y, "America/New_York", roll_dst = "boundary")
force_tz(y, "America/New_York", roll_dst = "post")

## DST skipped and repeated
y <- ymd_hms("2010-03-14 02:05:05 UTC", "2014-11-02 01:35:00", tz = "UTC")
force_tz(y, "America/New_York", roll_dst = c("NA", "pre"))
force_tz(y, "America/New_York", roll_dst = c("boundary", "post"))

## Heterogeneous time-zones:

x <- ymd_hms(c("2009-08-07 00:00:01", "2009-08-07 01:02:03"))
force_tzs(x, tzones = c("America/New_York", "Europe/Amsterdam"))
force_tzs(x, tzones = c("America/New_York", "Europe/Amsterdam"), tzone_out = "America/New_York")

x <- ymd_hms("2009-08-07 00:00:01")
force_tzs(x, tzones = c("America/New_York", "Europe/Amsterdam"))
}
\seealso{
\code{\link[=with_tz]{with_tz()}}, \code{\link[=local_time]{local_time()}}
}
\keyword{chron}
\keyword{manip}
