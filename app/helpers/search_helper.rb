module SearchHelper
  def search(relation, query, keys, word_junction: "OR", property_junction: "OR")
    if query.nil? || query.blank?
      return relation
    end
    if query.match(/^[a-zA-Z0-9_\s-]+$/)
      words = query.scan(/[a-zA-Z0-9_-]+/)
      query_template = ""

      constraints = []
      keys.each do |key|
        key_constraints = []
        words.each do |word|
          key_word_constraint = key.to_s + " LIKE '%#{word}%'" 
          key_constraints << key_word_constraint
        end  
        constraints << key_constraints.join(" #{word_junction} ") # match ANY word vs match ALL words
      end
      query_string = constraints.join(" #{property_junction} ") # match ANY key vs match ALL keys
      
      return relation.where(query_string)
    else
      return false # Bad query string, possibly unsafe characters
    end
  end
end