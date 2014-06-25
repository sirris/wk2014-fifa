import re, glob, time

fl = glob.glob('./belrus_*')
events = []  
#print 'ts\tbel\tres'
for fname in fl:
  timestamp = float(fname.split('_')[1].rstrip('.html'))
  timetuple = time.gmtime(timestamp)
  hourminute = str(timetuple.tm_hour + 2) + ':' + ('0' + str(timetuple.tm_min))[-2:]
  fin = open(fname, 'r')
  html = fin.read()
  fin.close()
  regex = re.compile('<div class="d-statChart-8000079-last15-away d-statChart-away hidden"> </div><script type="chart-data">\[\{"value" :(\d+?),"color" : "#009648"\},\{"value" :(\d+?),"color" : "#FFF"\}\]</script>')
  res = regex.findall(html)[0]
#  print hourminute + '\t' + res[0] + '\t' + res[1]

  regex = re.compile("<span class=\"lb-post-time\" data-timeutc=\"(.+?)\".+?event-text'>(.+?)</span></div> </div>")
  events.extend( regex.findall(html) )
for event in set(events):
  print event[0] + '\t' + event[1]
  
