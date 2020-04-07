require 'json'

SO_ACCOUNTS = JSON.parse File.read '../stackoverflow/northwoods/accounts.json'
SO_BADGES = JSON.parse File.read '../stackoverflow/northwoods/badges.json'
SO_COMMENTS = JSON.parse File.read '../stackoverflow/northwoods/comments.json'
SO_IMAGES = JSON.parse File.read '../stackoverflow/northwoods/images.json'
SO_POSTS = JSON.parse File.read '../stackoverflow/northwoods/posts.json'
SO_POSTS2VOTES = JSON.parse File.read '../stackoverflow/northwoods/posts2votes.json'
SO_TAGS = JSON.parse File.read '../stackoverflow/northwoods/tags.json'
SO_USERS = JSON.parse File.read '../stackoverflow/northwoods/users.json'
SO_USERS2BADGES = JSON.parse File.read '../stackoverflow/northwoods/users2badges.json'

@questions = []

def get_questions
    puts "Getting all questions"
    SO_POSTS.each { |post| @questions << post if post["postType"] == "question" }
    puts "Number of questions = #{@questions.length}"
end

def open_file
    File.write("stackoverflow.md", "Stack Overflow Conversion to Markdown - #{Time.now} \n")
end

def write_to_file(text)
    File.write("stackoverflow.md", text, mode: "a")
end

def extract_question_data
    @questions.each do |question|
        title = question["title"]
        body = question["bodyMarkdown"]
        write_to_file "# " + title + "\n\n"
        write_to_file "#{body} \n\n"
    end
end

open_file
get_questions
extract_question_data
    

