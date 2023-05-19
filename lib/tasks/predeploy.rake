desc 'Perform tasks necessary to pre-empt a deployment'
task :predeploy do
	Rake::Task['assets:precompile'].invoke
	# Rake::Task['appengine:exec'].invoke('bundle exec rails db:migrate')
end
