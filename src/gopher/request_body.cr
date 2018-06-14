struct RequestBody
  def initialize(selector : String)
    @selector = !selector ? "" : selector
  end

  def root?
    selector.blank? || selector == "/"
  end

  getter selector
end
