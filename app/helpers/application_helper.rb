module ApplicationHelper
  def flash_me(type)
    case type
      when :alert
        "alert alert-danger"
      when :error
        "alert alert-danger"
      when :notice
        "alert alert-info"
      when :success
        "alert alert-success"
      else
        type.to_s
    end
  end
end
