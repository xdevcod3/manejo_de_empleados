require "csv"

module MyEx
    class Ex < StandardError
        def initialize(message)
           super(message) 
        end
    end
end

class Empleados
    attr_accessor :nombre, :apellido, :salario
    def initialize(nombre, apellido, salario)
        @nombre = nombre
        @apellido = apellido
        @salario = salario
    end
end


class ManeoEmpleado < Empleados
    attr_accessor :lista_de_empleado
    def initialize
        @lista_de_empleado = []
    end

    def agregar_empleado(empleado)
        if empleado.nombre.nil? || empleado.apellido.nil? || empleado.salario.nil?
            raise MyEx::Ex.new("Debes poner los tres informaciones del empleado")
        else
            @lista_de_empleado << empleado
            puts "Empleado anadido"
        end    
    end

    def monstrar_empleados
        if @lista_de_empleado.empty?
            raise MyEx::Ex.new("La lista se empleados esta vacia")
        end
        @lista_de_empleado.each do |empleado|
            puts "El empleado #{empleado.nombre} #{empleado.apellido} tiene un salario de #{empleado.salario} $"
        end
    end

    def salario_promedio
        salarios = []
        raise  MyEx::Ex.new("No puedes hacer este operacion, la lista de empleados esta vacia ")  if @lista_de_empleado.empty?
        @lista_de_empleado.each do |empleado|
            salarios.push(empleado.salario)
        end
        puts "Promedio de los salario :  #{salarios.sum / salarios.size}"
    end

    def incrementar_salarios(nombre, apellido, porcentaje) 
        raise  MyEx::Ex.new("El procentaje de ser > 0") if porcentaje <= 0
        raise  MyEx::Ex.new("No puedes hacer este operacion, no tienes empleado")  if @lista_de_empleado.empty?
        usuario = @lista_de_empleado.select {|empleado| empleado.nombre == nombre && empleado.apellido == apellido}
        raise MyEx::Ex.new("Este empleado no esta en tu lista de empleados ") if usuario.empty?
            
        usuario.each do |empleado| 
            empleado.salario += empleado.salario * (porcentaje / 100.0) 
        end
        puts "salario incrementado de #{porcentaje} %"
    end

    def guardar_csv
        file_path = "empleados.csv"
        if File.exist?(file_path)

                CSV.open(file_path, "a") do |row|
                    raise  MyEx::Ex.new("No puedes hacer este operacion, la lista de empleados esta vacia ")  if @lista_de_empleado.empty?
                    @lista_de_empleado.each do |empleado|
                        row << [empleado.nombre,  empleado.apellido, empleado.salario]
                    end 
                end 

        else
                CSV.open(file_path, "w") do |row|
                    raise  MyEx::Ex.new("No puedes hacer este operacion, la lista de empleados esta vacia ")  if @lista_de_empleado.empty?
                    row << ["Nombre","Apellido","Salario"]
                    @lista_de_empleado.each do |empleado|
                        row << [empleado.nombre,  empleado.apellido, empleado.salario]
                    end 
                end

        end
        puts "Los empleados ya estan en le archivo #{file_path}"
    end
end


menu = '''
         Sistema de gestión de empleados
        -------------------------------
        1- Ver los empleados
        2- Agregar empleados
        3- Incrementar Salario de un empleado por %
        4- ver salario promedio de los empleados
        5- Agregar los empleados a un Arcchivo csv
        0- Parar el programa 87
    '''

def sClean
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
        system("cls")
    else
        system("clear")
    end   
end
def when_end(value)
    sleep(value)
    puts "Toca enter para regrasr al menu"
    gets.chomp 
    sClean()
end

sClean()
numero = nil
maneo_empleado = ManeoEmpleado.new
while numero != 0
    
    #menu
    puts menu
    begin
        print "numero: " 
        numero = Integer(gets.chomp)
        case numero
        when 1
            puts "1- "
            begin
                maneo_empleado.monstrar_empleados
            rescue MyEx::Ex=> exception
                puts exception.message
                when_end(0.5)
                next
            end
            when_end(2)
        when 2
            puts "2- Agregar Empleado"
            begin
                print "Nombre: "
                nombre = gets.chomp
                print "Apellido: "
                apellido = gets.chomp
                print "Salario: "
                salario = Integer(gets.chomp) 
            rescue MyEx::Ex => exception
                puts exception.message
                when_end(1)
                next
            rescue => exception
                puts exception.message
                when_end(1)
            else
                maneo_empleado.agregar_empleado(Empleados.new(nombre, apellido, salario))
                when_end(2)
            end

        when 3
            puts "3- Incrementar Salario de un empleado por %"
            begin
                print "Nombre: "
                nombre = gets.chomp
                print "Apellido: "
                apellido = gets.chomp
                print "Porcentaje: "
                porcentaje = Float(gets.chomp)
            rescue MyEx::Ex => exception
                puts exception.message
                when_end(3)
            rescue ArgumentError => exception
                puts "el porcentaje de ser un numero ej: 10 "
                when_end(1)
            else
                maneo_empleado.incrementar_salarios(nombre, apellido, porcentaje)
                when_end(2)
            end
        when 4
            puts "4- ver salario promedio de los empleados"
            begin
                maneo_empleado.salario_promedio
            rescue MyEx::Ex => exception
                puts exception.message
                when_end(1)
                next
            end
            when_end(2)

        when 5 
            puts "5- Agregar los empleados a un Arcchivo csv"
            begin
                maneo_empleado.guardar_csv
            rescue MyEx::Ex => exception
                puts exception.message
                when_end(1)
                next            
            end
            when_end(2)
        when 0
            nil
        else
            when_end(1)
        end


    rescue => exception
        puts exception.message
        when_end(1)
    end
end

puts "Adios ############"