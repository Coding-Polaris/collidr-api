# Post-mortem:

  Configuration, setup, learning patterns and gems to which I'm not yet accustomed, and finally just overthinking what I actually need to meet the requirements kept me from meeting all of them.

  Ultimately, I don't regret going with TDD, since this let me know my code was robust and works, where I was able to complete it. I also don't regret learning how to implement pub-sub and using a small piece of it to generate event logs and decouple models.

  I do realize my attempt to make a rudimentary front end (in the non-api repo) and adding auth0 was not at all part of the assignment and kept me from doing the required work, but it was a valuable learning experience nonetheless.

  If I were to attempt this again, the first thing I'd learn is jobs and Redis management, store my current rate limit etc. either on the DB or in Redis, and consult those to know when to execute GitHub API polls and clear them from the job queue.

# What this has:

- What I believe to be a 95% realized model layer.

  - Full, working test coverage for requested model features (see ./spec/models/)

  - Ratings that use (mostly) decoupled pub sub that can be 
  retooled to use jobs to only calculate average rating after
  some arbitrary cooldown to manage demand.

  Note the app doesn't do this -- it's something I had in mind and spent way too much time thinking about, given that it wasn't likely to be a problem. That said, I didn't want to fire it on every after_update of a Rating.

  - Create the pieces of the timeline and assemble an array based on requested user and timestamps

  - Create timeline item for when rating surpasses 4. I rate limited this to once every month or so.

# What it doesn't:

  - Endpoints for retrieval/posting. Commenting, posting, etc. would not be terribly complex to implement; make sure the routes exist, get the item the user asks for, connect it based on the information and item_params they ask for, etc.

  - Storing the user's GitHub timeline, possibly as ActivityItems. I'd poll on user create if the user's found to have a valid GitHub username through querying the GitHub API, as I found the API was able to tell me when a GitHub name doesn't exist.

  - Why store the activity instead of polling it live? Two reasons. First, the GH API doesn't allow you to search by timestamp, though it does provide the time of events. I would have had to find some way of mixing my timeline items with what had might as well be randomly timed GH items, which is possible but would lead to a messy glut of items.

  Second, overall this would result in fewer repeated queries since account creation is once and jobs to update the GH timeline (say, once every five minutes per user with GH name) would come at intervals we manage and can therefore predict instead of unpredictable, sporadic requests as timelines are requested. It wouldn't be precisely live, but then neither is the GH API itself (once every five minutes)

  - A job system for queueing up GH requests such that the API's polling rate is respected.