module GamesHelper
  # def mobile_device?
  #   request.user_agent =~ /Mobile|webOS/
  # end
  
  def result_for_calendar(result)
    case result
      when 'win'
        '◯'
      when 'lose'
        '×'
      when 'draw'
        '△'
      when 'scheduled'
        'ー'
      else
        result
    end
  end
end
