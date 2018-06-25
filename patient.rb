class Patient

attr_reader :age
attr_reader :pression
attr_reader :hepatomegalie
attr_reader :pressionmin

def initialize (age,pression,hepatomegalie)
     @age = age
     @pression = pression
     @hepatomegalie = hepatomegalie
     @pressionmin = 45 + pression * 1.5
end

def existeHepatomegalie
	return (@hepatomegalie == 1)
end

def get_binding
	return binding()	
end


end