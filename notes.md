# TODO

## Now
* Request Timeout errors
* *optimization: post:score: only update recent posts instead of all posts*
* add animation to show DELETE requests
* ajax timeout
* display
    * original score
    * negative points
    * days ago

## Soon
* optimization: post:collect: only update changed data (already done via rails?)
* reddit integration
* replace sports feeds with nba versions
* model validations
    * rspec test cases
* retweet top post of each day (calculate formula)
    * delete twitter old posts
* rspec test cases

## Later
* highlight date in html
* sort by non-decayed score
* configure unicorn web server
* embed actual twitter posts (Twitter-supported method)
* style list items using score
* security
    * resolve potential HTML injection for post.text
    * authentication
* update clicked date when item is clicked
* post:collect retweet processing
    * filter out?
    * get real nfavorites instead of 0?
* store display source (cnnbrk -> CNN Breaking News)
    * post.user.name
