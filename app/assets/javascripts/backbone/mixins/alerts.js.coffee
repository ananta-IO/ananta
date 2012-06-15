Ananta.Mixins.Alerts =
	alert: (body, options) ->
		body         		or= ''
		options      		or= {}
		options.title		or= ''
		options.fadeIn      or= false unless options.fadeIn == false
		# options.callback	or= null

		id = "alert-#{Math.floor(Math.random()*10000000)}"
		$('body').append("
			<div id='#{id}' class='modal #{if options.fadeIn then "fade in" else ""}'>
				<div class='modal-header'>
					<a class='close' data-dismiss='modal'>×</a>
					<h2>#{options.title}</h2>
				</div>
				<div class='modal-body scrl'>
					#{body}
				</div>
			</div>
		")
		$("##{id}").modal('keyboard': true, 'backdrop': true).modal('show')