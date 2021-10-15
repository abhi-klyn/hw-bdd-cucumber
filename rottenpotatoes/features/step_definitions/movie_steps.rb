# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
      Movie.create(title: movie[:title], rating: movie[:rating], release_date:movie[:release_date])
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  fail "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
    if uncheck
        if rating_list == "all"
            rating_list = Movie.all_ratings
        else
            rating_list = rating_list.split(", ")
        end
        rating_list.each do | irating |
            uncheck("ratings_#{irating}")
        end
    else
        if rating_list == "all"
            rating_list = Movie.all_ratings
        else
            rating_list = rating_list.split(", ")
        end
        rating_list.each do | irating |
            check("ratings_#{irating}")
        end        
    end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  @movies = Movie.all
  @movies.each do |movie|
      page.body.include?(movie.title).should == true
  end  
end

When /I should see movies of rating: (.*)/ do |rating_list|
  
  if rating_list == "all"
     filtered_ratings = Movie.all_ratings
  else
     filtered_ratings = rating_list.split(", ")
  end
  @movies = Movie.all
  @movies.each do |movie|
    if filtered_ratings.include?(movie.rating)
      page.body.include?(movie.title).should == true
    else
      page.body.include?(movie.title).should == false
    end
  end

end
