json.cities @cities
json.post_qty @posts.size if @user
json.city_qty @user.posts.map {|post| post.city_id}.uniq.size if @user
json.trending_counts @trending_counts

json.posts do
    json.array! @trending_posts do |post|
      json.extract! post, :id, :name, :description, :user_id, :city_id,:category,:latitude,:longitude, :votes, :created_at
      # json.upvoted_by_current_user post.voted_up_by? @current_user if @current_user
      
      json.time_ago time_ago_in_words(post.created_at)
      json.city City.find(post[:city_id])
      json.tags post.tag_list

    end
  end



#   Post id: 1, name: "lkjfsdljf", description: "jdslfjlj", user_id: 1, city_id: nil, created_at: "2018-12-06 05:27:43", updated_at: "2018-12-06 05:27:43", votes: 0