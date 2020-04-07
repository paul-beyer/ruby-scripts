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

