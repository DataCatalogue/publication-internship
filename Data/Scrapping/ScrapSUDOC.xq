declare namespace rslt ='http://www.w3.org/2005/sparql-results#';
declare namespace math = 'java:java.util.UUID';

let $x := http:send-request(<http:request method='get' href='https://data.idref.fr/sparql?default-graph-uri=&amp;query=select+distinct+%3Fidref+where+%7B%3Fidref+dcterms%3Asubject+%3Chttp%3A%2F%2Fwww.idref.fr%2F029903440%2Fid%3E%7D&amp;format=application%2Fsparql-results%2Bxml&amp;timeout=0&amp;debug=on&amp;run=+Run+Query+' timeout='10'/>)
let $y := http:send-request(<http:request method='get' follow-redirect='true'><http:multipart media-type ="application/xml"/></http:request>, 'https://www.sudoc.fr/163810230.xml')

for $i in $x//rslt:uri/text()
  return try{
  let $k:=replace(string($i), '/id', '')
  let $j:=concat($k,'.xml')
  let $l:=replace(string($j), 'http', 'https')
  let $f:=fetch:xml(fetch:text(string($l)))
  let $m:= $f//record/controlfield[1]
  return file:write(concat('data/Output/output_',$m,'.xml'),$f,map { "method": "xml","encoding":"UTF-8","media-type":''})}
  catch *{
   'error'
  }
  