FriendlyId.defaults do |config|
	config.use :slugged, :reserved
	config.reserved_words = %w(
		a
		about
		account
		add
		admin
		answers
		api
		app
		apps
		archive
		archives
		auth
		better
		blog
		cache
		changelog
		codereview
		compare
		config
		connect
		contact
		create
		data
		delete
		direct_messages
		downloads
		edit
		edit 
		email
		enterprise
		faq
		favorites
		feed
		feeds
		follow
		followers
		following
		gist
		help
		home
		hosting
		index 
		invitations
		invite
		jobs
		lists
		login
		logout
		logs
		map
		maps
		mine
		new 
		news
		oauth
		oauth_clients
		openid
		organizations
		plans
		popular
		privacy
		projects
		q
		questions
		register
		remove
		replies
		rss
		save
		search
		security
		sessions
		settings
		shop
		show 
		signup
		sitemap
		ssl
		status
		stories
		styleguide
		subscribe
		tasks
		terms
		todo
		tour
		translations
		trends
		unfollow
		unsubscribe
		url
		user
		widget
		widgets
		wiki
		xfn
		xmpp
	)
end