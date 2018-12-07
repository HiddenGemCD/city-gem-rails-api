
json.posts do
    json.array! @posts do |post|
      json.extract! post, :id, :name, :description, :user_id, :city_id,:category,:latitude,:longitude, :votes
      # json.upvoted_by_current_user post.voted_up_by? @current_user if @current_user
      json.city City.find(post[:city_id])
      json.tags post.tag_list
        
      json.user do
            json.extract! post.user, :name, :avatar, :city, :gender
      end
    end
  end



#   Post id: 1, name: "lkjfsdljf", description: "jdslfjlj", user_id: 1, city_id: nil, created_at: "2018-12-06 05:27:43", updated_at: "2018-12-06 05:27:43", votes: 0