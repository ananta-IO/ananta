Ananta.Mixins.Collections = 
	shuffle: (o) ->
		i = o.length
		while i
			j = parseInt(Math.random() * i)
			x = o[--i]
			o[i] = o[j]
			o[j] = x
		o