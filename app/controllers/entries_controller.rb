class EntriesController < InheritedResources::Base
  respond_to :json

  protected

  def end_of_association_chain
    super.order(Entry.arel_table[:created_at].desc)
  end
end
