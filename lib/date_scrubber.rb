module DateScrubber
  def self.scrub(time)
    date = time[0..9].delete("-").to_i
  end
end
