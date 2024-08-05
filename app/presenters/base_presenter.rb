class BasePresenter < SimpleDelegator
  def initialize(model, view = nil)
    @view = view
    super(model)
  end

  def h
    @view
  end
end
