#!/usr/bin/perl
use strict;
use warnings;
use DBIx::Array::Connect 0.06; #path
use Geo::GoogleEarth::Pluggable 0.16; #Polygon
use Geo::GoogleEarth::Pluggable::Plugin::AsGeoJSON; #preloading plugin not needed

=head1 NAME

Geo-GoogleEarth-Pluggable-Plugin-AsGeoJSON-example.pl - Geo::GoogleEarth::Pluggable::Plugin:AsGeoJSON Examaple

=head2 Configuration

Update the PostgreSQL connetion information in the provided database-connections-config.ini file

=cut

my $document = Geo::GoogleEarth::Pluggable->new;
my $database = DBIx::Array::Connect->new->connect('gis');

#Select data from PostgreSQL
my @gisdata  = $database->sqlarrayhash(&gis_data_sql);

#Add each row as Google Earth document object
$document->AsGeoJSON(%$_) foreach @gisdata;

#Print the Google Earth KML document
print $document->render;

sub gis_data_sql {
  return qq{
SELECT 'LineString'                                                                                                      AS "name", /* column aliases for sqlarrayhash */
       ST_AsGeoJSON(ST_GeomFromText('LINESTRING(-77.29 39.07,-77.42 39.26,-77.27 39.31,-77.29 39.07)'))                  AS "json"

UNION ALL

SELECT 'LineString'                                                                                                      AS "name",
       ST_AsGeoJSON(ST_GeomFromText('LINESTRING(-71.160281 42.258729,-71.160837 42.259113,-71.161144 42.25932)'))        AS "json"

UNION ALL

SELECT 'MULTILINESTRING'                                                                                                 AS "name",
       ST_AsGeoJSON(ST_GeomFromText('MULTILINESTRING((-71.160281 42.258729,-71.160837 42.259113,-71.161144 42.25932))')) AS "json"

UNION ALL

SELECT 'Point'                                                                                                           AS "name",
       ST_AsGeoJSON(ST_GeomFromText('POINT(-71.064544 42.28787)'))                                                       AS "json"

UNION ALL

SELECT 'Polygon'                                                                                                         AS "name",
       ST_AsGeoJSON(ST_GeomFromText('POLYGON((-71.1776585052917 42.3902909739571,-71.1776820268866 42.3903701743239,
-71.1776063012595 42.3903825660754,-71.1775826583081 42.3903033653531,-71.1776585052917 42.3902909739571))'))            AS "json"

UNION ALL

SELECT 'MultiPolygon'                                                                                                    AS "name",
       ST_AsGeoJSON(ST_GeomFromText('MULTIPOLYGON(
                                                   (
                                                     (
                                                      -71.1031880899493 42.3152774590236,
                                                      -71.1031627617667 42.3152960829043,
                                                      -71.102923838298 42.3149156848307,
                                                      -71.1023097974109 42.3151969047397,
                                                      -71.1019285062273 42.3147384934248,
                                                      -71.102505233663 42.3144722937587,
                                                      -71.10277487471 42.3141658254797,
                                                      -71.103113945163 42.3142739188902,
                                                      -71.10324876416 42.31402489987,
                                                      -71.1033002961013 42.3140393340215,
                                                      -71.1033488797549 42.3139495090772,
                                                      -71.103396240451 42.3138632439557,
                                                      -71.1041521907712 42.3141153348029,
                                                      -71.1041411411543 42.3141545014533,
                                                      -71.1041287795912 42.3142114839058,
                                                      -71.1041188134329 42.3142693656241,
                                                      -71.1041112482575 42.3143272556118,
                                                      -71.1041072845732 42.3143851580048,
                                                      -71.1041057218871 42.3144430686681,
                                                      -71.1041065602059 42.3145009876017,
                                                      -71.1041097995362 42.3145589148055,
                                                      -71.1041166403905 42.3146168544148,
                                                      -71.1041258822717 42.3146748022936,
                                                      -71.1041375307579 42.3147318674446,
                                                      -71.1041492906949 42.3147711126569,
                                                      -71.1041598612795 42.314808571739,
                                                      -71.1042515013869 42.3151287620809,
                                                      -71.1041173835118 42.3150739481917,
                                                      -71.1040809891419 42.3151344119048,
                                                      -71.1040438678912 42.3151191367447,
                                                      -71.1040194562988 42.3151832057859,
                                                      -71.1038734225584 42.3151140942995,
                                                      -71.1038446938243 42.3151006300338,
                                                      -71.1038315271889 42.315094347535,
                                                      -71.1037393329282 42.315054824985,
                                                      -71.1035447555574 42.3152608696313,
                                                      -71.1033436658644 42.3151648370544,
                                                      -71.1032580383161 42.3152269126061,
                                                      -71.103223066939 42.3152517403219,
                                                      -71.1031880899493 42.3152774590236
                                                     )
                                                   ),
                                                   (
                                                     (
                                                      -71.1043632495873 42.315113108546,
                                                      -71.1043583974082 42.3151211109857,
                                                      -71.1043443253471 42.3150676015829,
                                                      -71.1043850704575 42.3150793250568,
                                                      -71.1043632495873 42.315113108546
                                                     )
                                                   )
                                                 )',4326))                                                               AS "json"
           };
}
