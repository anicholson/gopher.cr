struct RequestBody
  ROOT = "/"

  def initialize(selector : String)
    @selector = !selector ? ROOT : selector
  end

  def root?
    selector == ROOT
  end

  def relative_selector
    selector.lchop('/')
  end

  getter selector
end
