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

end