# TODO

## Now
* model validations
* optimize
    * post:score:   only update recent posts instead of all posts
    * post:collect: only update changed data
    * add db indices
        * source
        * tid
        * profile for others

## Soon
* retweet top post of each day (calculate formula)
    * delete twitter posts
* rspec test cases

## Later
* style list items using score
* security
    * resolve potential HTML injection for post.text
    * authentication
* update clicked date when item is clicked
* post:collect retweet processing
    * filter out?
    * get real nfavorites instead of 0?
* replace sports feeds with nba versions
* store display source (cnnbrk -> CNN Breaking News)
    * post.user.name
