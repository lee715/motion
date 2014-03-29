define([
	'./track/story'
], (Story)->

	$.fn.story = (opts)->
		story(opts)
	story = (opts)->
		ctl = (new Story(opts)).promise()
		ctl
			.on('done', ->
				console.log('is done now')
			)
		ctl
	return story
)