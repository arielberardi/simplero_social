module ApplicationHelper
  def time_from_last_update(comment)
    return nil if comment.nil?

    if comment.updated_at - comment.created_at < 1
      "Commented #{time_ago_in_words(comment.created_at)} ago"
    else
      "Updated #{time_ago_in_words(comment.updated_at)} ago"
    end
  end

  def time_from_last_comment(post)
    return nil if post.nil?

    if post.updated_at - post.created_at < 1
      "Commented #{time_ago_in_words(post.created_at)} ago"
    else
      "Updated #{time_ago_in_words(post.updated_at)} ago"
    end
  end

  def form_submit_name(action_name)
    action_name == 'edit' ? 'Save' : 'Create'
  end

  def form_title_name(action_name)
    action_name == 'edit' ? 'Edit' : 'Create'
  end
end
