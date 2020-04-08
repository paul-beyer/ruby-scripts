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


def get_questions
    questions = []
    puts "Getting all questions"
    SO_POSTS.each { |post| questions << post if post["postType"] == "question" }
    puts "Number of questions = #{questions.length}"
    questions
end

def open_file
    File.write("stackoverflow.md", "Stack Overflow Conversion to Markdown - #{Time.now} \n")
end

def write_to_file(text)
    File.write("stackoverflow.md", text, mode: "a")
end

def get_user_name(answer)
    return answer['ownerDisplayName'] if answer['ownerDisplayName']
    answer['ownerUserId'] > 0 ? SO_USERS.find { |user| user['id'] == answer['ownerUserId']}['realName'] : "Community User"
end

def get_comment_user_name(comment)
    return comment['userDisplayName'] if comment['userDisplayName']
    comment['userId'] > 0 ? SO_USERS.find { |user| user['id'] == comment['userId']}['realName'] : "Community User"
end

# not called yet
def fix_markdown(text)
    fixed_text = text
    tic_count = text.count("```")
    fixed_text = "#{fixed_text}\n```" if tic_count.odd? 
    fixed_text
end

def write_comments(comments, post_id)
    comments_for_post = comments[post_id]
    write_to_file("### Comments\n\n") if comments_for_post
    comments_for_post&.each {|comment| write_to_file(">#{comment['text']} - #{get_comment_user_name(comment)} - #{comment['creationDate']}\n\n") }
end

def extract_question_data(questions, answers, comments)
    questions.each do |question|
        title = question["title"]
        body = question["bodyMarkdown"]
        write_to_file "\# #{title}\n\n"
        write_to_file "#{body} \n\n"
        write_comments(comments, question['id']) 
        answers_for_question = answers[question["id"]] || []
        write_to_file "### #{answers_for_question.length} #{answers_for_question.length == 1 ? 'Answer' : 'Answers'}\n\n" 
        answers_for_question.each_with_index do |answer,index|
            userName = get_user_name(answer)
            write_to_file "Answer #{index+1} by #{userName} #{question['acceptedAnswerId'] == answer['id'] ? '(Accepted Answer)' : ''}\n\n"
            write_to_file "#{answer['bodyMarkdown']}\n\n" 
            write_comments(comments, answer['id'])
        end
    end
end

def group_answers_by_question 
  all_answers = SO_POSTS.find_all { |post| post['postType'] == 'answer' }
  all_answers.group_by { |answer| answer['parentId'] }
end

def group_comments_by_post 
    SO_COMMENTS.group_by { |comment| comment['postId'] }
end

open_file
questions = get_questions
answers = group_answers_by_question 
comments = group_comments_by_post
extract_question_data(questions, answers, comments)
    

