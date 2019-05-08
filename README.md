# Quantifying Change

This is a repository for a web archiving problem explored at the [Fields-CQAM Industrial Problem Solving Workshop](http://www.fields.utoronto.ca/activities/18-19/fields-cqam-ipsw).

![chalkboard](https://user-images.githubusercontent.com/3834704/57253288-5b059b00-701c-11e9-885f-e8f18b36ab36.jpeg)

.csv files are crawl data organised in columns:

1. Date
2. Domain
3. URL 
4. Text

## URL for 3.5GB NDP Text File

<http://ruebot.net/227-www-ndp-ca.txt>

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