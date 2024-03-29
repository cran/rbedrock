% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/entity.R
\name{Entity}
\alias{Entity}
\alias{get_entity_data}
\alias{get_entity_values}
\alias{get_entity_value}
\alias{put_entity_values}
\alias{put_entity_value}
\alias{put_entity_data}
\title{Load and store Entity NBT data}
\usage{
get_entity_data(db, x, z, dimension)

get_entity_values(db, x, z, dimension)

get_entity_value(db, x, z, dimension)

put_entity_values(db, x, z, dimension, values)

put_entity_value(db, x, z, dimension, value)

put_entity_data(db, data)
}
\arguments{
\item{db}{A bedrockdb object.}

\item{x, z, dimension}{Chunk coordinates to extract data from.
\code{x} can also be a character vector of db keys.}

\item{values}{A list of nbt objects}

\item{value}{An nbt object.}

\item{data}{A named-list specifying key-value pairs.}
}
\value{
\code{get_entity_data()} returns a named-list of nbt data.
\code{get_entity_values()} returns a single nbt value.
}
\description{
Entity data (tag 50) holds a list of NBT values for mobs and other entities
in the game. After 1.18.30, entity data was migrated to a new actor digest
format and no longer saved with chunk data.

\code{get_entity_data()} and \code{get_entity_value()} load Entity
data from \code{db}. \code{get_entity_data()} will silently drop and keys not
representing Entity data. \code{get_entity_value()} supports loading
only a single value. \code{get_entity_values()} is a synonym for
\code{get_entity_data()}.

\code{put_entity_values()}, \code{put_entity_value()}, and
\code{put_entity_data()} store BlockEntity data into \code{db}.
}
