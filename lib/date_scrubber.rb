module DateScrubber
  def self.scrub(csv_time)
    date = csv_time[0..9]
    time = csv_time[11..18].split(":")
    time.map do |time|
      time.to_i
    end
    puts date
    puts time
  end
end
