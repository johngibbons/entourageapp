class QueryPresenter < BasePresenter

  def init(query_name, query_value)
    @query_name = query_name
    @query_value = query_value.to_s
    @current_value = get_current(@query_name)
    #generate copy of current params but don't affect current
    @current_value_copy = Marshal.load(Marshal.dump(@current_value))
  end

  def toggle
    if in_params?(@query_value)
      remove(@query_value)
    else
      add(@query_value)
    end
  end

  def query_text(total_results)
    if @model[:search] && @model[:search] != ""
      "<span class='results-count'>#{h.pluralize(total_results, 'result')} for </span> <span class='filters-text'>#{param_to_text('category_id')} #{param_to_text('perspective_id')} #{param_to_text('tag_list')}</span> <span class='search-text'>\"#{@model[:search]}\"</span>"
    else
      "<span class='results-count'>#{h.pluralize(total_results, 'result')} </span> <span class='filters-text'>#{param_to_text('category_id')} #{param_to_text('perspective_id')} #{param_to_text('tag_list')}</span>"
    end
  end

  def remove_query
    if @model[:search] && @model[:search] != ""
      h.link_to h.search_index_path  do
          h.raw("<i id='remove-search' class='fa fa-times-circle'></i>")
      end
    end
  end

  def status
    if in_params?(@query_value)
      "selected"
    else
      "unselected"
    end
  end

  def icon
    if in_params?(@query_value)
      "filter-checkbox checked fa fa-check-square"
    else
      "filter-checkbox unchecked fa fa-square"
    end
  end

  def count(value)
    if in_params?(@query_value)
      ""
    else
      "(#{value})"
    end
  end

  def get_current(name)
    # always return an array
    p = @model["#{name}"]
    if p.is_a? String
      p = [p]
    else
      p
    end
  end

  private

    def add(value)
      @model.delete :page
      @current_value_copy.push(value)
      @model.merge({ "#{@query_name}" => @current_value_copy })
    end

    def remove(value)
      @model.delete :page
      @current_value_copy.delete(value)
      @model.merge({ "#{@query_name}" => @current_value_copy })
    end

    def in_params?(value)
      @current_value.include? value
    end

    def param_to_text(param)
      values = get_current(param)
      if param != "tag_list"
        values = values.map do |val|
          Upload.send("#{param}_name", val.to_i)
        end
      end
      if values.any?
        if param == "tag_list"
          values.join(" and ") + " : "
        else
          values.join(" or ") + " : "
        end
      else
        ""
      end
    end

end
