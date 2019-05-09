# Quantifying Change

This is a repository for a web archiving problem explored at the [Fields-CQAM Industrial Problem Solving Workshop](http://www.fields.utoronto.ca/activities/18-19/fields-cqam-ipsw).

![chalkboard](https://user-images.githubusercontent.com/3834704/57253288-5b059b00-701c-11e9-885f-e8f18b36ab36.jpeg)

.csv files are crawl data organised in columns:

1. Date
2. Domain
3. URL 
4. Text

# Collections

## Wayback Machine URL vs Archive-It Wayback Machine URL

Archive-It Wayback Machine URL prefix is `https://wayback.archive-it.org/227/` (where `227` refers to the collection ID - in this case, political party websites).

For *example*, <https://wayback.archive-it.org/227/20140805/http://www.ndp.ca/>.

Internet Archive Wayback Machine URL prefix is 

`https://web.archive.org/web/`

For *example*, <https://web.archive.org/web/20140410/http://www.ndp.ca/>

## URL for 3.5GB NDP Text File

<http://ruebot.net/227-www-ndp-ca.txt>

## Crawl Dates in the NDP Subset

<https://github.com/ianmilligan1/ipsw-quantifying-change/blob/master/NDP-dates.txt>

## Data from the Toronto PanAm Collection 
The collection number for this collection is `5421`, you will need to change that from `227` (which is the Political Party collection number) when looking at Wayback crawls, etc.

All links (internal) from the event homepage: <https://github.com/ianmilligan1/ipsw-quantifying-change/blob/master/panam-all-links.txt>

All text: <https://ruebot.net/5421-www-toronto2015-org.txt>

# Important NDP Dates

- 28 November 2005: election called.
- 23 January 2006: federal election.
- 14 October 2008: federal election.
- 2 May 2011: federal election.
- July 2011: NDP leader announces leave of absence; replaced by interim.
- 22 August 2011: NDP leader dies.
- 24 March 2012: New NDP leader selected.
- 19 October 2015: federal election.
- 10 April 2016: NDP leader loses vote of confidence.
- 1 October 2017: New NDP leader selected.

# Scripts (for reproducibility)

## Scripts used to generate the files

### Script that generated the links from just the homepage

```scala
import io.archivesunleashed._
import io.archivesunleashed.matchbox._

RecordLoader.loadArchives("/mnt/vol1/data_sets/cpp/cpp_warcs_accession_01/partner.archive-it.org/cgi-bin/getarcs.pl/*.gz", sc)
  .keepValidPages()
  .keepUrlPatterns(Set("(?i)http://www.ndp.ca/".r))
  .map(r => (r.getCrawlDate, ExtractLinks(r.getUrl, r.getContentString)))
  .flatMap(r => r._2.map(f => (r._1, f._1.replaceAll("^\\s*www\\.", ""), f._2.replaceAll("^\\s*www\\.", ""))))
  .filter(r => r._2 != "" && r._3 != "")
  .countItems()
  .filter(r => r._2 > 5)
  .saveAsTextFile("/home/i2millig/fields/ndp-all-homepage-links")
```

### Script that generated all the links from all NDP pages

```scala
import io.archivesunleashed._
import io.archivesunleashed.matchbox._

RecordLoader.loadArchives("/mnt/vol1/data_sets/cpp/cpp_warcs_accession_01/partner.archive-it.org/cgi-bin/getarcs.pl/*.gz", sc)
  .keepValidPages()
  .keepUrlPatterns(Set("(?i)http://www.ndp.ca/.*".r))
  .map(r => (r.getCrawlDate, ExtractLinks(r.getUrl, r.getContentString)))
  .flatMap(r => r._2.map(f => (r._1, f._1.replaceAll("^\\s*www\\.", ""), f._2.replaceAll("^\\s*www\\.", ""))))
  .filter(r => r._2 != "" && r._3 != "")
  .countItems()
  .filter(r => r._2 > 5)
  .saveAsTextFile("/home/i2millig/fields/ndp-all-links")
```