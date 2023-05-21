# README

This README would normally document whatever steps are necessary to get the
application up and running.

So, you've cloned the repo! Nice work, there, skip. But to do start developing, you'll need to collect some dependencies.

- Make sure your active ruby version is `Ruby 3.2.2`
- Contact me for credentials keys. You'll need `config/credentials/development.key` and `config/credentials/test.key`. Only I get `config/production.key`, sorry ;).
- Run `bundle install` to install the requisite gems.
- Once you have credentials keys, run `RAILS_ENV=development rake db:create` and `RAILS_ENV=test rake db:create` to create a development and test database.
- You'll likewise need to install and set up `redis` and `sidekiq`, configured with the appropriate credentials (check the files!) for the `development` environment.
- Run `rake db:migrate` to format the database.
- Run `rake db:seed` to populate the database with demo data. (you can rerun this command at any time, to repopulate).
- Code. Code like you've never coded before, and may the winds of inspiration be ever under your wings.
- Run the test suite with a simple `rspec`. Please add specs for any newly introduced features, or better yet, write them before you introduce new code.

#### Deprecated

## Integrating with Google Cloud Platform for continuous deployment

This was a real pain in the butt to figure out, but it finally works. Even though I've taken the project off of GCP for now to save costs, I'm documenting the setup here.

First of all, when we checkout our code with github actions, we do so to the latest ubuntu instance. So, we needed to run `bundle lock --add-platform x86_64-linux` to add the ability to build on linux to our project (I think this comes from Ruby, but I haven't investigated it closely).

- We use Workload Identity Federation (WIF) to administer keyless authentication (which is the current best practice from a security standpoint), as opposed to generating long-lived credentials and storing them as a Github Secret (which is a less technically involved authentication scheme).

- We use a Service Account (a non-human identity and resource) as opposed to a User (a human identity), since the deployment is performed programmatically.

The following are required to get it all working:

0. A Google App Engine Flexible Environment instance

1. A Workload Identity Pool

2. A Workload Identity Provider, created within the aforementioned pool, with 'OIDC' stuff, and the following mappings: {google.subject: assertion.sub, attribute.actor: assertion.actor, attribute.aud: assertion.aud, attribute.repository, assertion.repository}. Note: the last mapping (repository) isn't strictly necessary, but it's useful for restricting the provider's access to just the repository in question. Moreover, you can use it to restrict access to specific branches, though I haven't implemented this yet, as of the most recent editing of this sentence ;).

3. A Service Account with appropriate permissions (App Engine Admin, Workload Identity User, Service Account User, Storage Admin, Cloud Build Editor)

4. All appropriate APIs Enabled: (App Engine API, App Engine Admin API, Cloud Build API, and maybe some others... but these were the two I had to verify were enabled. If there are others that need to be manually enabled, the error logs seem to be good at prompting the user to enable APIs)

You must add the Service Account to the Workload Identity Pool AND you must "grant access" to the Service Account (from the Workload Identity Pool)

After all that, you can set up the workflow file as shown in the project. The `WORKFLOW_IDENTITY_PROVIDER_ID` is NOT the full url, it just begins with `projects/...`. The `SERVICE_ACCOUNT` is the full email, of the form `<SERVICE_ACCOUNT>@<PROJECT>.iam.gserviceaccount.com`.

The first deploy requires a long time to set everything up, so you should increase the timeout to 1800 (seconds).

If you're working in MacOS, you need to install gnu-sed, and configure it as follows:

`brew install gnu-sed`

Then add to your `$PATH`, by adding `export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"` to your `.bashrc` or `.zshrc` file.

To develop locally, start the rails server with `bin/dev` so that the application is reloaded on the fly! Otherwise, it's a pain in the butt because you have to recompile assets every time and restart the local server frequently.

Enjoy!
