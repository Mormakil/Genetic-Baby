class Patient

def initialize (age,pression,hepatomegalie)
     @age = age
     @pression = pression
     @pressionmin = 45 + pression * 1.5
end

def quelage
     return @age
end

def quellepression
     return @pression
end

def existehepatomegalie
	return (hepatomegalie == 1)
end

def get_binding
	return binding()	
end


end