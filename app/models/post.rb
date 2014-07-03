class Post < ActiveRecord::Base
  def to_s
    tz = 'Central Time (US & Canada)'
    ft = '%y/%m/%d-%H:%M:%S'

    "%-16s %20d %s %s %s %s %4d %4d %3d %s" % [
      source,
      tid,
                published.in_time_zone(tz).strftime(ft),
                  updated.in_time_zone(tz).strftime(ft),
      read    ?      read.in_time_zone(tz).strftime(ft) : "null",
      clicked ?   clicked.in_time_zone(tz).strftime(ft) : "null",
      nfavorite,
      nretweet,
      score,
      text,
    ]
  end
end
