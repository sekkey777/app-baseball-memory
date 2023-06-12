module GamesResultHelper
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
