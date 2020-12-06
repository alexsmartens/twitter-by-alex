module ApplicationHelper

  # Returns the full title on a per-page basis
  def full_title(page_title = '')
    base_title = "Twitter by Alex"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # Returns the original page number if it is an integer or 1 otherwise
  def validate_page_num(page_num)
    begin
      Integer(page_num) > 0 ? page_num : 1
    rescue ArgumentError
      1
    end
  end

end
