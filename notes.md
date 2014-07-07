# TODO

## Now
* DELETE route: DELETE /posts/id1,id2 (mark posts as read)
* cli interface

## Soon
* model validations
* retweet top five percentile
* add db indices
    * source
    * tid
    * profile for others
* rspec test cases

## Later
* post:score expensive: only update recent posts instead of all posts
* post:collect retweet processing
    * filter out?
    * get real nfavorites instead of 0?
* replace sports feeds with nba versions
* authentication
* store display source (cnnbrk -> CNN Breaking News)
    * post.user.name
