class Post < ActiveRecord::Base

  def url
    urls = URI.extract(text, ['http', 'https'])
    if urls.size < 1
      nil
    else
      urls[0]
    end
  end

  def clean_text
    re = URI::regexp(["http", "https"])
    text.gsub(re, '')
  end

  def days_old
    DateTime.now.utc.mjd - published.to_date.mjd
  end

  def to_s
    tz = 'Central Time (US & Canada)'
    ft = '%y/%m/%d-%H:%M:%S'

    "%-16s %20d %17s %17s %17s %17s %5d %5d %3d %3d %s" % [
      source,
      tid,
                published.in_time_zone(tz).strftime(ft),
                  updated.in_time_zone(tz).strftime(ft),
      read    ?      read.in_time_zone(tz).strftime(ft) : "null",
      clicked ?   clicked.in_time_zone(tz).strftime(ft) : "null",
      nfavorite,
      nretweet,
      score,
      score_decayed,
      text,
    ]
  end

end
