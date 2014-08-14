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

  def score_decayed
    if decay_factor = ENV['NEWS_SCORE_DECAY_FACTOR']
      decay_factor = 1 + days_old * decay_factor.to_f
    else
      # zero out score if days_old == 30
      # decrement score by 1/30 for each day passed
      decay_factor = 1 + days_old * (-1.0 / 30)
    end

    score * decay_factor
  end

  def <=> (other)
    other.score_decayed <=> score_decayed
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
