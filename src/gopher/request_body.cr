struct RequestBody
  def initialize(selector : String)
    @selector = !selector ? "" : selector
  end

  def root?
    selector.blank? || selector == "/"
  end

  def relative_selector
    selector.lchop('/')
  end

  getter selector
end
