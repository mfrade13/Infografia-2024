-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
print("Hola mundo!")

print("Distintos textos")
-- int float, string, bool

variable_enteros = 12
print(variable_enteros)

variables_flotantes = 1232.42
print( variables_flotantes )

cadenas_textos = "Una variable de textos o strings"
print( cadenas_textos )

print(true)

print(type( cadenas_textos ), type(variable_enteros), type( variables_flotantes ), type(true), type(print)	  )

variable_a = 54.2
suma = 123 + 412
variable_desconocida = 43

print(suma, (suma + variable_a))
print("Textos " .. " Concatenados")
print( variable_a .. " texto " .. suma)
print( tonumber( "134") + tostring( 23 ) )
print(tonumber( 44 , 16  ) )
print(43 + variable_desconocida)
arrays = {43,5455, 4343}
print(arrays[1], arrays[2], arrays[3], arrays[0])

persona = {
	genero = "M",
	edad = 20,
	altura = 1.70,
	ciudad = "Santa Cruz",
	nombre = "miguel",
	carnet = 2244393

}

print(persona, persona["genero"], persona["ciudad"], persona.nombre, persona[2])

-- FOR LOOPS
contador = 1
for i=3, 1, -1 do
	print("Arrays: elemento " .. arrays[i])
--	contador = contador + 1
end

for i, v in ipairs( arrays ) do
	print(i,v)
end

for k,v in pairs(persona) do
	print(k,v)
end

iterador = 2

repeat
	iterador = iterador + 2
	print("iterador " .. iterador)
until iterador > 10


-- EJERCICIOS
function factorial( n )
	producto = n
	for i=n-1, 1, -1 do
		producto = producto * i
	end
	return producto
end

function factorial_recursivo(n)
	if n == 0 then
		return 1
	end
	return n * factorial_recursivo(n-1)  -- factorial(5-1)  * 5 ... factorial (4-1) * 4 * 5 .....
end

print(factorial(5))
print( factorial_recursivo(6) )
-- EJERCICIO 1 
function fibonacci(n)
    a, b = 0, 1
    temporal = 0
    for i = 1, n-1 do
--        a=b ; b = a + b
        temporal = a + b 
        a = b
        b = temporal
    end
    return temporal
end
print(fibonacci(7))

-- EJERCICIO 2
function fibonacci_recursive(n)
    if n <= 1 then
        return n
    else
        return fibonacci_recursive(n - 1) + fibonacci_recursive(n - 2)
    end
end

print(fibonacci_recursive(7))



