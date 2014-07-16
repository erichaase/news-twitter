# TODO

## Now
* Add logging add-on
* Include date in score?
* Configure Unicorn web server
* Add animation to show DELETE requests
* Replace sports feeds with nba versions
* Optimization
    * post:score:   only update recent posts instead of all posts
    * post:collect: only update changed data
    * add db indices
        * source
        * tid
        * profile for others

## Soon
* model validations
    * rspec test cases
* retweet top post of each day (calculate formula)
    * delete twitter old posts
* rspec test cases

## Later
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
