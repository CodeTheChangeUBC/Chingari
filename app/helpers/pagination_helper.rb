module PaginationHelper
  
  def paginate(relation, page: 1, page_size: 100, page_max: 10, page_min: 1)
    page = [ [page, page_min].max, page_max ].min
    relation.offset((page-1)*page_size).limit(page_size)
  end

end